import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:uuid/uuid.dart';

import '../../../foundation/logger/nova_logger.dart';

/// 请求设备信息 作为 header 附加到请求中的拦截器
class HeaderInterceptor extends dio_pkg.Interceptor {
  HeaderInterceptor({DeviceInfoPlugin? deviceInfo, Connectivity? connectivity})
    : _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
      _connectivity = connectivity ?? Connectivity();

  final DeviceInfoPlugin _deviceInfo;
  final Connectivity _connectivity;

  /// 进程内稳定指纹（与硬件 UDID 区分）。
  final String _sessionFingerprint = const Uuid().v4();

  String? _cachedUdid;
  Future<Map<String, dynamic>>? _deviceHeadersFuture;

  @override
  void onRequest(dio_pkg.RequestOptions options, dio_pkg.RequestInterceptorHandler handler) {
    _attachHeaders(options, handler);
  }

  Future<void> _attachHeaders(dio_pkg.RequestOptions options, dio_pkg.RequestInterceptorHandler handler) async {
    try {
      final deviceHeaders = await _deviceHeadersOnce();
      final networkHeaders = await _networkHeaders();
      final localizationHeaders = _localizationHeaders();
      final deviceUUID = await _udid();

      options.headers.addAll({
        'X-DEVICE-INFO': jsonEncode(deviceHeaders),
        'X-NETWORK-INFO': jsonEncode(networkHeaders),
        'X-LOCALIZATION-INFO': jsonEncode(localizationHeaders),
        'X-USER-TYPE': 'visitor',
        'Accept-Language': localizationHeaders['language']! as String,
        'X-Timezone': localizationHeaders['timezone']! as String,
        'x-platform': _platformTag(),
        'uuid': deviceUUID,
      });
    } catch (e, st) {
      NovaLogger.d('HeaderInterceptor._attachHeaders', error: e, stackTrace: st);
    }
    handler.next(options);
  }

  String _platformTag() {
    if (Platform.isAndroid) return 'flutter/android';
    if (Platform.isIOS) return 'flutter/iOS';
    return 'flutter/${defaultTargetPlatform.name}';
  }

  Future<String> _udid() async {
    _cachedUdid ??= await FlutterUdid.udid;
    return _cachedUdid!;
  }

  Future<Map<String, dynamic>> _deviceHeadersOnce() {
    return _deviceHeadersFuture ??= _buildDeviceHeaders();
  }

  Future<Map<String, dynamic>> _buildDeviceHeaders() async {
    final size = _logicalScreenSize();
    final udid = await _udid();
    final headers = <String, dynamic>{
      'device_type': defaultTargetPlatform == TargetPlatform.iOS ? 'iphone' : 'android',
      'screen': [size.width.toInt(), size.height.toInt()],
      'device_fingerprint': _sessionFingerprint,
    };

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = await _deviceInfo.iosInfo;
      headers.addAll({'brand': ios.model, 'system': 'iOS ${ios.systemVersion}', 'ios_idfv': ios.identifierForVendor});
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final android = await _deviceInfo.androidInfo;
      headers.addAll({
        'brand': android.brand,
        'system': 'Android ${android.version.release}',
        'android_id': android.id,
      });
    }

    headers['hardware_uuid'] = udid;
    return headers;
  }

  /// 无 [BuildContext] 时用 [PlatformDispatcher.views] 推算逻辑像素尺寸。
  Size _logicalScreenSize() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return Size.zero;
    final view = views.first;
    final dpr = view.devicePixelRatio;
    if (dpr <= 0) return Size.zero;
    return Size(view.physicalSize.width / dpr, view.physicalSize.height / dpr);
  }

  Future<Map<String, dynamic>> _networkHeaders() async {
    final results = await _connectivity.checkConnectivity();
    final wifi = results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.ethernet);
    return {'type': wifi ? 'wifi' : 'cellular'};
  }

  Map<String, dynamic> _localizationHeaders() {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final language = dispatcher.locale.toLanguageTag();
    final now = DateTime.now();
    final timezone = now.timeZoneName;
    final offset = now.timeZoneOffset;
    final totalMinutes = offset.inMinutes;
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes.abs() % 60;
    final sign = totalMinutes >= 0 ? '+' : '-';
    final offsetString = '$sign${hours.abs().toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';

    return {
      'language': language,
      'timezone': timezone,
      'timezone_offset': offsetString,
      'timestamp': now.millisecondsSinceEpoch,
    };
  }
}
