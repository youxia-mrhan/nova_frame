import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/logger/nova_logger.dart';
import '../../telemetry/navigation/nav_telemetry_labels.dart';
import '../nova_route_observer.dart';

/// 给 NovaRouteObserver 使用的 debug 日志 mixin
mixin RouteObserverDebugLogMixin on RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _log(AppRouteEventType.push, route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _log(AppRouteEventType.pop, route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _log(AppRouteEventType.remove, route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute == null) return;
    _log(AppRouteEventType.replace, newRoute, oldRoute);
  }

  void _log(AppRouteEventType type, Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!kDebugMode) return;
    if (route is! PageRoute<dynamic>) return;
    final pageRoute = route;
    final prev = previousRoute is PageRoute<dynamic> ? previousRoute : null;

    // final currentSettingsName = route.settings.name;
    // final currentRuntimeType = route.runtimeType.toString();
    // final preSettingsName = prev?.settings.name ?? '-1';
    // final preRuntimeType = prev.runtimeType.toString();
    // debugPrint('[Current] $currentSettingsName --- $currentRuntimeType  (prev: $preSettingsName --- $preRuntimeType )');

    final current = NavTelemetryLabels.formatPageRoute(pageRoute);
    final prevLabel = prev != null ? NavTelemetryLabels.formatPageRoute(prev) : '-';
    NovaLogger.d('[Route] ${type.name}: $current  (prev: $prevLabel)');
  }
}
