import 'dart:convert';

import 'package:flutter/services.dart';

import '../../foundation/logger/nova_logger.dart';

class LoadAssetJsonUtil {
  LoadAssetJsonUtil._();

  /// 读取本地 json 文件（assets）。
  ///
  /// 示例：
  /// ```yaml
  /// flutter:
  ///   assets:
  ///     - assets/json/temp.json
  /// ```
  static Future<dynamic> loadJsonFromAssets({required String assetPath, String? package}) async {
    try {
      final jsonString = (package?.isNotEmpty ?? false)
          ? await rootBundle.loadString('packages/$package/$assetPath')
          : await rootBundle.loadString(assetPath);
      return json.decode(jsonString);
    } catch (e) {
      NovaLogger.d('读取 asset JSON 失败', error: e);
      return null;
    }
  }
}
