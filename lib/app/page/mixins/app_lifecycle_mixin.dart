import 'package:flutter/widgets.dart';

/// App 前后台 / 生命周期监听
mixin AppLifecycleMixin<T extends StatefulWidget> on State<T> {
  late final WidgetsBindingObserver _observer = _LifecycleObserver(onState: _handleState);
  AppLifecycleState? _lastState;

  AppLifecycleState? get lastLifecycleState => _lastState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_observer);
  }

  void _handleState(AppLifecycleState state) {
    _lastState = state;
    onAppLifecycleStateChanged(state);
  }

  /// 生命周期变化回调。
  @protected
  void onAppLifecycleStateChanged(AppLifecycleState state) {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_observer);
    super.dispose();
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  _LifecycleObserver({required this.onState});

  final ValueChanged<AppLifecycleState> onState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onState(state);
  }
}

