import 'dart:async';

import 'package:flutter/widgets.dart';

import '../telemetry/session/session_route_observer.dart';
import '../telemetry/navigation/nav_telemetry_labels.dart';
import 'mixins/route_observer_debug_log_mixin.dart';

/// 全局路由观察者
///
/// 监听 `didPush/didPop/didRemove/didReplace` 事件（适合埋点/调试）。
class NovaRouteObserver extends RouteObserver<PageRoute<dynamic>>
    with RouteObserverDebugLogMixin, SessionRouteObserverMixin {
  NovaRouteObserver._();

  static final NovaRouteObserver instance = NovaRouteObserver._();

  static final Stream<AppRouteEvent> events = _events.stream;
  static final _events = StreamController<AppRouteEvent>.broadcast();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _emit(AppRouteEventType.push, route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _emit(AppRouteEventType.pop, route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _emit(AppRouteEventType.remove, route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute == null) return;
    _emit(AppRouteEventType.replace, newRoute, oldRoute);
  }

  void _emit(AppRouteEventType type, Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PageRoute) return;
    final prev = previousRoute is PageRoute ? previousRoute : null;
    final event = AppRouteEvent(type: type, route: route, previousRoute: prev);
    _events.add(event);
  }
}

enum AppRouteEventType {
  push,
  pop,
  remove,
  replace,
}

class AppRouteEvent {
  const AppRouteEvent({
    required this.type,
    required this.route,
    required this.previousRoute,
  });

  final AppRouteEventType type;
  final PageRoute<dynamic> route;
  final PageRoute<dynamic>? previousRoute;

  String? get routeName => route.settings.name;

  String? get previousRouteName => previousRoute?.settings.name;

  /// 与 debug 日志一致的可读描述（含路径）
  String get routeDisplayLabel => NavTelemetryLabels.formatPageRoute(route);

  String? get previousRouteDisplayLabel =>
      previousRoute != null ? NavTelemetryLabels.formatPageRoute(previousRoute!) : null;
}

