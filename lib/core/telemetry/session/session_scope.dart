import 'package:flutter/widgets.dart';
import 'package:nova_frame/core/telemetry/session/session_tracker.dart';

/// 每次进入页面，都会生成一个新的 sessionId，和埋点关联
/// 使用InheritedWidget共享，并通知子Widget刷新
class SessionScope extends InheritedWidget {
  const SessionScope({
    super.key,
    required this.sessionId,
    required super.child,
  });

  final String? sessionId;

  static String? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SessionScope>()?.sessionId;
  }

  @override
  bool updateShouldNotify(SessionScope oldWidget) => sessionId != oldWidget.sessionId;
}

class SessionBinding extends StatelessWidget {
  const SessionBinding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: SessionTracker.sessionIdNotifier,
      child: child,
      builder: (context, _, wrappedChild) {
        final sid = SessionTracker.sessionIdForRoute(ModalRoute.of(context));
        return SessionScope(sessionId: sid, child: wrappedChild!);
      },
    );
  }
}
