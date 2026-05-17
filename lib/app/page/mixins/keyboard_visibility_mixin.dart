import 'package:flutter/widgets.dart';

/// 键盘弹起/收起监听
mixin KeyboardVisibilityMixin<T extends StatefulWidget> on State<T> {
  late final WidgetsBindingObserver _observer = _KeyboardObserver(onMetrics: _syncKeyboardVisible);
  bool _keyboardVisible = false;

  /// 当前键盘是否可见
  bool get keyboardVisible => _keyboardVisible;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_observer);
    _syncKeyboardVisible();
  }

  void _syncKeyboardVisible() {
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    final next = bottomInset > 0;
    if (next == _keyboardVisible) return;
    _keyboardVisible = next;
    onKeyboardVisibilityChanged(next);
  }

  /// 键盘弹起/收起回调。
  @protected
  void onKeyboardVisibilityChanged(bool visible) {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_observer);
    super.dispose();
  }
}

class _KeyboardObserver extends WidgetsBindingObserver {
  _KeyboardObserver({required this.onMetrics});

  final VoidCallback onMetrics;

  @override
  void didChangeMetrics() {
    onMetrics();
  }
}

