import 'dart:convert';

import '../link/nova_link_scheme.dart';

abstract final class NovaUri {
  NovaUri._();

  /// 生成页面跳转时的uri字符串，格式为：`/some/page?k=v...`
  static String buildPushPath({required String path, Map<String, dynamic>? query}) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final params = <String, String>{};
    query?.forEach((key, value) {
      if (value == null) return;
      if (value is num || value is bool || value is String) {
        params[key] = value.toString();
      } else {
        params[key] = jsonEncode(value);
      }
    });
    if (params.isEmpty) return normalizedPath;
    final q = Uri(queryParameters: params).query;
    return '$normalizedPath?$q';
  }

  /// 输出 页面 path 与 参数 转为的 [Uri]
  static Uri buildRouteUri({required String path, Map<String, dynamic>? query}) {
    return Uri.parse(buildPushPath(path: path, query: query));
  }

  /// 生成站外深链（Push / Link）用的 URI：
  /// `novaframe://link?path=%2Fsome%2Fpage&k=v...`
  /// 单元测试：test/widget_test.dart
  static Uri buildDeepLinkUri({
    required String path,
    Map<String, dynamic>? query,
    String scheme = NovaLinkScheme.prod,
  }) {
    final inner = buildRouteUri(path: path, query: query);
    final qp = <String, String>{
      'path': inner.path,
      ...inner.queryParameters,
    };
    return Uri(
      scheme: scheme,
      host: NovaLinkScheme.host,
      queryParameters: qp,
    );
  }
}
