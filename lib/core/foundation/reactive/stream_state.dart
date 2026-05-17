import 'dart:async';

import 'package:flutter/widgets.dart';

/// 封装 Stream 广播
class NovaStreamNotifier<T> {
  NovaStreamNotifier() : _c = StreamController<T>.broadcast();

  final StreamController<T> _c;
  bool _isClosed = false;

  bool get isClosed => _isClosed;

  Stream<T> get stream => _c.stream;

  void add(T event) {
    if (_isClosed) return;
    _c.add(event);
  }

  void addError(Object error, [StackTrace? stackTrace]) {
    if (_isClosed) return;
    _c.addError(error, stackTrace);
  }

  Future<void> close() async {
    if (_isClosed) return;
    _isClosed = true;
    await _c.close();
  }
}

typedef NovaStreamObs<T> = NovaStreamNotifier<T>;

/// 封装 [StreamBuilder]
class NovaStreamBox<T> extends StatefulWidget {
  const NovaStreamBox({
    super.key,
    required this.stream,
    required this.builder,
    required this.notifier,
    this.autoDispose = true,
    this.seed,
    this.child,
  });

  final Stream<T> stream;
  final NovaStreamNotifier<T>? notifier;
  final bool autoDispose;
  final T? seed;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snap, Widget? child) builder;
  final Widget? child;

  @override
  State<NovaStreamBox<T>> createState() => _NovaStreamBoxState<T>();
}

class _NovaStreamBoxState<T> extends State<NovaStreamBox<T>> {
  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.notifier?.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: widget.stream,
      initialData: widget.seed,
      builder: (context, snap) => widget.builder(context, snap, widget.child),
    );
  }
}
