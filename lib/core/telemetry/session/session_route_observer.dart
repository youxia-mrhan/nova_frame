import 'package:flutter/widgets.dart';
import 'package:nova_frame/core/telemetry/models/nav_operation.dart';
import 'package:nova_frame/core/telemetry/session/session_tracker.dart';
import 'package:nova_frame/core/telemetry/telemetry_config.dart';
import 'package:nova_frame/core/telemetry/uploader/session_uploader.dart';

import 'package:nova_frame/example/demo_home_page.dart';
import 'package:nova_frame/core/navigation/nova_router.dart';

/// 用于「回到根」时触发埋点上传
bool pageRouteIsTelemetryRoot(PageRoute<dynamic> route) {
  final n = route.settings.name;
  return n == DemoHomeRoute.name || n == DemoRouteRt.path;
}

/// 监听全局路由
mixin SessionRouteObserverMixin on RouteObserver<PageRoute<dynamic>> {
  /// 冷启动后，根页第一次 [didPush] 时触发一次上传，之后不再因路由回根而上传
  static bool _didColdStartRootTelemetryFlush = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (!TelemetryConfig.enabled) return;
    if (route is! PageRoute<dynamic>) return;
    final pr = route;
    () async {
      await SessionTracker.handlePush(pr, entryRouteNavOp: NavOperation.push);
      if (pageRouteIsTelemetryRoot(pr) && !_didColdStartRootTelemetryFlush) {
        _didColdStartRootTelemetryFlush = true;
        await SessionUploader.tryFlushRootStackPipeline();
      }
    }();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (!TelemetryConfig.enabled) return;
    if (route is! PageRoute<dynamic>) return;
    final popped = route;
    () async {
      await SessionTracker.handlePop(popped, exitRouteNavOp: NavOperation.pop);
    }();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (!TelemetryConfig.enabled) return;
    if (route is! PageRoute<dynamic>) return;
    final removed = route;
    () async {
      await SessionTracker.handlePop(removed, exitRouteNavOp: NavOperation.remove);
    }();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (!TelemetryConfig.enabled) return;
    () async {
      if (oldRoute is PageRoute<dynamic>) {
        await SessionTracker.handlePop(oldRoute, exitRouteNavOp: NavOperation.replace);
      }
      if (newRoute is PageRoute<dynamic>) {
        final nr = newRoute;
        await SessionTracker.handlePush(nr, entryRouteNavOp: NavOperation.replace);
      }
    }();
  }
}
