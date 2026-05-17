import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 封装 ValueNotifier
class NovaNotifier<T> extends ValueNotifier<T> {
  NovaNotifier(super.value);

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @override
  set value(T newValue) {
    if (_isDisposed) return;
    super.value = newValue;
  }

  @override
  void addListener(VoidCallback listener) {
    if (_isDisposed) return;
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (_isDisposed) return;
    super.removeListener(listener);
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    super.dispose();
  }
}

typedef NovaObs<T> = NovaNotifier<T>;

/// [ValueListenableBuilder] 的缩写封装
class NovaBuilder<T> extends StatefulWidget {
  const NovaBuilder({super.key, required this.ls, required this.bx, this.autoDispose = true, this.cd});

  final ValueListenable<T> ls;
  final bool autoDispose;
  final Widget Function(BuildContext context, T value, Widget? cd) bx;
  final Widget? cd;

  @override
  State<NovaBuilder<T>> createState() => _NovaBuilderState<T>();
}

class _NovaBuilderState<T> extends State<NovaBuilder<T>> {
  @override
  void dispose() {
    if (widget.autoDispose && widget.ls is NovaNotifier<T>) {
      (widget.ls as NovaNotifier<T>).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(valueListenable: widget.ls, builder: widget.bx, child: widget.cd);
  }
}
