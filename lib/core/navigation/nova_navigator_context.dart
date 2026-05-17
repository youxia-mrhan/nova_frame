import 'package:flutter/widgets.dart';

/// 全局 context
///
/// 注意：只有在 App 启动完成、Navigator 构建后 `currentContext` 才可用。
///
/// final ctx = NovaNavigatorContext.context;
/// if (ctx != null) {
///   ...
/// }
class NovaNavigatorContext {
  NovaNavigatorContext._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState? get navigator => navigatorKey.currentState;
}

