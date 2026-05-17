import 'dart:async';

/// 防抖：一定时间内连续触发，只执行最后一次
class Debouncer {
  Timer? _timer;

  void run(
    void Function() action, {
    required int milliseconds,
  }) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

/// 节流：一定时间内连续触发，只执行第一次
class Throttler {
  Timer? _timer;
  bool _locked = false;

  void run(
    void Function() action, {
    required int milliseconds,
  }) {
    if (_locked) return;
    _locked = true;
    action();
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      _locked = false;
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _locked = false;
  }
}

/// 便捷全局实例
final debouncer = Debouncer();
final throttler = Throttler();

