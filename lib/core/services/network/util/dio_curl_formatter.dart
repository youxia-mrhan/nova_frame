import 'dart:convert';

import 'package:dio/dio.dart';

/// 生成请求的 curl 命令
/// 用于调试，复制命令到终端可以直接请求
abstract final class DioCurlFormatter {
  DioCurlFormatter._();

  static String format(RequestOptions options, {String? proxy}) {
    final parts = <String>['curl', '-X', options.method.toUpperCase()];

    final proxyValue = proxy?.trim();
    if (proxyValue != null && proxyValue.isNotEmpty) {
      parts.addAll(['-x', _shellQuote(proxyValue)]);
    }

    final headers = Map<String, dynamic>.from(options.headers);
    final contentType = options.contentType;
    if (contentType != null && !headers.keys.any((k) => k.toLowerCase() == 'content-type')) {
      headers['Content-Type'] = contentType;
    }

    for (final entry in headers.entries) {
      final value = entry.value;
      if (value == null) continue;
      parts.addAll(['-H', _shellQuote('${entry.key}: $value')]);
    }

    parts.addAll(_bodyArgs(options));
    parts.add(_shellQuote(options.uri.toString()));
    return parts.join(' ');
  }

  static List<String> _bodyArgs(RequestOptions options) {
    final data = options.data;
    if (data == null) return [];

    final method = options.method.toUpperCase();
    if (method == 'GET' || method == 'HEAD') return [];

    if (data is FormData) {
      final parts = <String>[];
      for (final field in data.fields) {
        parts.addAll(['-F', _shellQuote('${field.key}=${field.value}')]);
      }
      for (final file in data.files) {
        final name = file.value.filename ?? 'file';
        parts.addAll(['-F', _shellQuote('${file.key}=@$name')]);
      }
      return parts;
    }

    final body = switch (data) {
      final String s => s,
      _ => jsonEncode(data),
    };
    return ['-d', _shellQuote(body)];
  }

  /// 单引号包裹，兼容 bash/zsh 粘贴执行。
  static String _shellQuote(String value) => "'${value.replaceAll("'", r"'\''")}'";
}
