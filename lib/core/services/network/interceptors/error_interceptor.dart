import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../app/res/app_strings.dart';
import '../../../foundation/logger/nova_logger.dart';


/// 网络请求异常基类
class NetworkException implements Exception {
  final String? errorMsg;
  final int? errorCode;

  NetworkException({this.errorMsg, this.errorCode});
}

/// 服务器业务错误异常
class ServerException extends NetworkException {
  ServerException({required super.errorMsg, required super.errorCode});
}

/// 客户端错误异常
class ClientException extends NetworkException {
  ClientException({required super.errorMsg, required super.errorCode});
}

/// 网络连接异常
class ConnectionException extends NetworkException {
  ConnectionException({required super.errorMsg, super.errorCode});
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 交给 [AuthInterceptor] 先入队；若未配置登录回调，Auth 会 next 透传至此，仍保持原始 DioException。
    final code = err.response?.statusCode;
    if (code == 401) {
      _logDioFailure(err);
      handler.next(err);
      return;
    }

    // 转换为自定义异常
    final networkException = _handleDioError(err);
    _logDioFailure(err, mapped: networkException);

    // 创建新的 DioException，但将我们的自定义异常作为 error
    final customError = DioException(
      requestOptions: err.requestOptions,
      error: networkException,
      type: err.type,
      response: err.response,
      message: networkException.errorMsg,
      stackTrace: err.stackTrace,
    );

    // 使用 handler.reject 传递自定义异常
    handler.reject(customError);
  }

  static void _logDioFailure(DioException err, {NetworkException? mapped}) {
    final ro = err.requestOptions;
    final buffer = StringBuffer('[Network] ${ro.method} ${ro.uri} | type=${err.type}');
    final status = err.response?.statusCode;
    if (status != null) {
      buffer.write(' status=$status');
    }
    final msg = mapped?.errorMsg ?? err.message;
    if (msg != null && msg.isNotEmpty) {
      buffer.write(' | $msg');
    }
    NovaLogger.d(buffer.toString(), error: err.error ?? err, stackTrace: err.stackTrace);
  }

  /// 处理 Dio 异常，转换为自定义异常
  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ConnectionException(errorMsg: AppStrings.connectionTimeout, errorCode: error.response?.statusCode);
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            // 解析服务器错误消息
            final message = _parseErrorMessage(error.response?.data) ?? AppStrings.serverError;
            return ServerException(errorMsg: message, errorCode: statusCode);
          } else if (statusCode >= 400) {
            // 解析客户端错误消息
            final message = _parseErrorMessage(error.response?.data) ?? AppStrings.clientError;
            return ClientException(errorMsg: message, errorCode: statusCode);
          }
        }
        return NetworkException(errorMsg: AppStrings.unknownErr, errorCode: statusCode);
      case DioExceptionType.cancel:
        return NetworkException(errorMsg: AppStrings.requestCancelled, errorCode: error.response?.statusCode);
      case DioExceptionType.connectionError:
        return ConnectionException(errorMsg: AppStrings.connectionError, errorCode: error.response?.statusCode);
      case DioExceptionType.unknown:
        return NetworkException(errorMsg: AppStrings.unknownErr, errorCode: error.response?.statusCode);
      case DioExceptionType.badCertificate:
        return NetworkException(errorMsg: AppStrings.certificateError, errorCode: error.response?.statusCode);
    }
  }

  /// 解析错误消息
  String? _parseErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    try {
      dynamic data = responseData;

      // 如果是字符串，尝试解析为 JSON
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (e) {
          // 如果解析失败，返回原始字符串
          return data;
        }
      }

      // 如果是 Map，尝试各种可能的错误消息字段
      if (data is Map<String, dynamic>) {
        // 常见的错误消息字段
        final possibleKeys = ['message', 'error', 'msg', 'detail', 'description'];

        for (final key in possibleKeys) {
          if (data.containsKey(key) && data[key] != null) {
            final value = data[key];

            // 如果是嵌套对象
            if (value is Map<String, dynamic> && value.containsKey('message')) {
              return value['message']?.toString();
            }

            // 直接返回字符串值
            if (value is String && value.isNotEmpty) {
              return value;
            }
          }
        }

        // 如果有 error 对象且包含 message
        if (data['error'] is Map<String, dynamic>) {
          final errorObj = data['error'] as Map<String, dynamic>;
          if (errorObj['message'] != null) {
            return errorObj['message'].toString();
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
