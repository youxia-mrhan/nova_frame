import 'package:nova_frame/core/services/storage/storage.dart';
import 'package:nova_frame/core/services/storage/storage_keys.dart';

/// 埋点全局开关
abstract final class TelemetryConfig {
  TelemetryConfig._();

  /// 是否开启埋点
  static bool enabled = false;

  static Future<void> setEnabled(bool value) async {
    enabled = value;
    await (await Storage.prefs()).setBool(StorageKeys.telemetryEnabledV1, value);
  }

  /// 冷启动从 [SharedPreferences] 恢复；
  /// 无记录则保持 [enabled] 默认值。
  static Future<void> loadPersistedOrDefault() async {
    final prefs = await Storage.prefs();
    if (!prefs.containsKey(StorageKeys.telemetryEnabledV1)) return;
    enabled = prefs.getBool(StorageKeys.telemetryEnabledV1) ?? true;
  }
}
