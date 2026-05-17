import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../app/res/app_strings.dart';
import '../../foundation/logger/nova_logger.dart';
import '../storage/storage.dart';
import '../storage/storage_keys.dart';
import 'config/api_config.dart';
import 'config/api_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/curl_log_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/header_interceptor.dart';

enum HttpMethod { get, post, put, delete, patch }

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  dio_pkg.Dio? _dio;

  AuthInterceptor? _authInterceptor;

  ApiHosts get apiHosts => ApiConfig().apiHosts;

  static ApiClient get shared => _instance;

  ApiClient._internal();

  /// 首次 [request] / [dio] / [proxy] 前自动创建，已创建则复用
  void _ensureDio() {
    if (_dio != null) return;
    _initDio();
  }

  /// 创建或替换 Dio（切换环境时整实例重建）
  void _initDio() {
    final previous = _dio;
    final d = dio_pkg.Dio(
      dio_pkg.BaseOptions(
        baseUrl: apiHosts.apiUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );

    final auth = AuthInterceptor(d);
    _authInterceptor = auth;
    // 注意添加拦截器的顺序
    // 401 须先到 Auth，再到 Error，否则Auth 永远收不到 401
    d.interceptors.addAll([
      HeaderInterceptor(),
      auth,
      if (kDebugMode) CurlLogInterceptor(),
      ErrorInterceptor(),
    ]);

    if (kDebugMode) {
      d.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }

    _applyDebugProxyIfNeeded(d);

    _dio = d;
    previous?.close();
  }

  /// 调试代理：在 `main` 里 `ApiClient.setProxy('host:port')`，下次 [_initDio] 生效（含切换环境后重建）。
  static void setProxy(String? hostAndPort) {
    final t = hostAndPort?.trim();
    ApiConfig.caughtAddress = (t == null || t.isEmpty) ? null : t;
    shared._initDio();
  }

  void _applyDebugProxyIfNeeded(dio_pkg.Dio d) {
    final caught = ApiConfig.caughtAddress?.trim();
    if (caught == null || caught.isEmpty) return;
    (d.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.findProxy = (uri) => 'PROXY $caught';
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }

  /// 登录成功后，逐条重试挂起请求
  Future<void> notifyLoginSuccess() async {
    _ensureDio();
    await _authInterceptor?.notifyLoginSuccess();
  }

  /// 清空挂起的401请求队列
  void notifyLoginCancelled() {
    _authInterceptor?.notifyLoginCancelled();
  }

  /// 切换环境（写入本地 prefs 并重建 Dio）
  Future<void> switchEnvironment(ApiEnvironment env) async {
    await Storage.prefSetInt(StorageKey(StorageKeys.apiEnvironmentV1), env.index);
    ApiConfig.currentEnvironment = env;
    _initDio();
  }

  dio_pkg.Dio get dio {
    _ensureDio();
    return _dio!;
  }

  /// [baseUrl] 与 [path] 拼成绝对 URL，避免改写共享 [Dio.options.baseUrl] 导致并发竞态。
  static String _absoluteUrl(String baseUrl, String path) {
    final base = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final p = path.trim();
    final segment = p.startsWith('/') ? p : '/$p';
    return '$base$segment';
  }

  static bool _isSuccessfulHttp(int? status) => status != null && status >= 200 && status < 300;

  /// 发送请求
  Future<ApiResponse<T>> request<T>(String path, {
    dynamic data,
    String? baseUrl,
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      _ensureDio();
      final client = _dio!;
      dynamic sendData = data;
      Map<String, dynamic>? queryParams = queryParameters;
      if (queryParams != null) {
        queryParams.removeWhere((key, value) => value == null || value == '');
      }
      final curBaseUrl = baseUrl ?? apiHosts.apiUrl;
      final requestTarget = baseUrl != null ? _absoluteUrl(curBaseUrl, path) : path;

      final response = await client.request(
        requestTarget,
        queryParameters: queryParams,
        data: sendData,
        options: dio_pkg.Options(method: method.name.toUpperCase(), headers: headers),
      );

      if (_isSuccessfulHttp(response.statusCode)) {
        dynamic payload = response.data;
        if (payload is String) {
          try {
            payload = jsonDecode(payload);
          } on FormatException catch (e, st) {
            final ex = NetworkException(
              errorMsg: AppStrings.invalidJsonResponse(e),
              errorCode: response.statusCode,
            );
            NovaLogger.d('[ApiClient] invalid JSON for $requestTarget', error: ex, stackTrace: st);
            throw ex;
          }
        }
        return ApiResponse<T>.fromJson(payload, parser: parser);
      } else {
        final ex = NetworkException(errorMsg: AppStrings.requestFailed, errorCode: response.statusCode);
        NovaLogger.d(
          '[ApiClient] HTTP ${response.statusCode} for $requestTarget',
          error: ex,
        );
        throw ex;
      }
    } on dio_pkg.DioException catch (e, st) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      final ro = e.requestOptions;
      NovaLogger.d('[ApiClient] ${ro.method} ${ro.uri}', error: e, stackTrace: st);
      rethrow;
    } on NetworkException {
      rethrow;
    }
  }
}
