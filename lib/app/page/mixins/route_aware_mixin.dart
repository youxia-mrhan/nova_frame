import 'package:flutter/widgets.dart';

import '../../../core/navigation/nova_route_observer.dart';

/// RouteAware 监听当前页面：push/pop/cover/uncover 等
mixin RouteAwareMixin<T extends StatefulWidget> on State<T> implements RouteAware {
  PageRoute<dynamic>? _route;

  PageRoute<dynamic>? get currentRoute => _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = ModalRoute.of(context);
    if (next is! PageRoute) return;
    if (identical(next, _route)) return;

    if (_route != null) {
      NovaRouteObserver.instance.unsubscribe(this);
    }

    _route = next;
    NovaRouteObserver.instance.subscribe(this, _route!);
  }

  @override
  void dispose() {
    NovaRouteObserver.instance.unsubscribe(this);
    super.dispose();
  }

  /// 当前页面被 push 进栈，且成为 top
  @override
  void didPush() {
    onDidPush();
  }

  /// 当前页面被 pop 出栈
  @override
  void didPop() {
    onDidPop();
  }

  /// 其他页面被 push 覆盖在当前页面上方
  @override
  void didPushNext() {
    onDidPushNext();
  }

  /// 覆盖在当前页上方的页面被 pop
  @override
  void didPopNext() {
    onDidPopNext();
  }

  @protected
  void onDidPush() {}

  @protected
  void onDidPop() {}

  @protected
  void onDidPushNext() {}

  @protected
  void onDidPopNext() {}
}

