import 'package:flutter/foundation.dart';

/// 同时监听多个 [Listenable]，任一源改变时都发出通知。
Listenable novaAnyMerged(Iterable<Listenable> sources) {
  return Listenable.merge(sources.toList(growable: false));
}

/// 只要有一个vns值发生改变，就触发通知
final class VnsAnyLatch {
  VnsAnyLatch(Iterable<Listenable> sources)
      : _merged = Listenable.merge(sources.toList(growable: false)) {
    _listener = () => _pending = true;
    _merged.addListener(_listener);
  }

  final Listenable _merged;
  late final VoidCallback _listener;
  bool _pending = false;

  Listenable get merged => _merged;

  /// 若自上次调用后任一源通知过，则返回 `true` 并清零内部标记；否则 `false`。
  bool consumeAnyNotified() {
    final v = _pending;
    _pending = false;
    return v;
  }

  void dispose() {
    _merged.removeListener(_listener);
  }
}

/// 只有所有vns值发生改变，才会触发通知
final class NovaAllDirtyGate {
  NovaAllDirtyGate(
    List<Listenable> sources, {
    this.onRoundComplete,
  }) : _sources = List<Listenable>.unmodifiable(sources) {
    _dirty = List<bool>.filled(_sources.length, false);
    for (var i = 0; i < _sources.length; i++) {
      final idx = i;
      void listener() {
        _dirty[idx] = true;
        if (_dirty.every((e) => e)) {
          for (var j = 0; j < _dirty.length; j++) {
            _dirty[j] = false;
          }
          onRoundComplete?.call();
        }
      }

      _listeners.add(listener);
      _sources[idx].addListener(listener);
    }
  }

  final List<Listenable> _sources;
  final void Function()? onRoundComplete;

  final List<VoidCallback> _listeners = <VoidCallback>[];
  late List<bool> _dirty;

  void dispose() {
    for (var i = 0; i < _sources.length; i++) {
      _sources[i].removeListener(_listeners[i]);
    }
    _listeners.clear();
  }
}
