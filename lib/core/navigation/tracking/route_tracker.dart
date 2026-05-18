import 'package:nova_frame/core/telemetry/telemetry_config.dart';

/// 埋点/ 路由跟踪工具
/// 在发起导航前会调用
abstract final class NovaRouteTracker {
  NovaRouteTracker._();

  static void Function({required String path, required String description})? onTrack;

  static void track({required String path, required String description}) {
    if (!TelemetryConfig.enabled) return;
    // NovaLogger.d('[NovaRouteTracker] $description ($path)');
    onTrack?.call(path: path, description: description);
  }
}
