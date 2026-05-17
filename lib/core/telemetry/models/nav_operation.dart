/// 路由行为
abstract final class NavOperation {
  NavOperation._();

  /// [RouteObserver.didPush]
  static const String push = 'push';

  /// [RouteObserver.didPop]
  static const String pop = 'pop';

  /// [RouteObserver.didReplace]
  static const String replace = 'replace';

  /// [RouteObserver.didRemove]
  static const String remove = 'remove';
}
