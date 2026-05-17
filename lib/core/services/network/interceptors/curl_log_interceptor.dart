import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../foundation/logger/nova_logger.dart';
import '../config/api_config.dart';
import '../util/dio_curl_formatter.dart';

/// curl 命令拦截器
class CurlLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final curl = DioCurlFormatter.format(
        options,
        proxy: ApiConfig.caughtAddress,
      );
      NovaLogger.d('[curl] copy below:\n$curl');
    }
    handler.next(options);
  }
}
