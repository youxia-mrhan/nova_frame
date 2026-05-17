import 'dart:async';

class EventId<T> {
  const EventId(this.id);

  final String id;
}

/// 全局 EventBus，跨页面通信
///
/// 特性：
/// - 一对多：对同一个 EventId 的订阅，都会收到 emit 的 payload
/// - 定向推送：对同一个 EventId + targetPageId 的订阅，才会收到 emitTo 的 payload，避免循环通知
class EventBus {
  EventBus._();

  static final EventBus instance = EventBus._();

  final Map<String, StreamController<Object?>> _controllers = <String, StreamController<Object?>>{};

  String _key<T>(EventId<T> eventId, {String? targetPageId}) {
    final base = eventId.id;
    if (targetPageId == null || targetPageId.isEmpty) return base;
    return '$base::$targetPageId';
  }

  Stream<T> on<T>(EventId<T> eventId) {
    final key = _key(eventId);
    final controller = _controllers.putIfAbsent(
      key,
      () => StreamController<Object?>.broadcast(),
    );
    return controller.stream.cast<T>();
  }

  Stream<T> onTarget<T>(EventId<T> eventId, {required String targetPageId}) {
    final key = _key(eventId, targetPageId: targetPageId);
    final controller = _controllers.putIfAbsent(
      key,
      () => StreamController<Object?>.broadcast(),
    );
    return controller.stream.cast<T>();
  }

  void emit<T>(EventId<T> eventId, T payload) {
    final key = _key(eventId);
    final controller = _controllers[key];
    controller?.add(payload);
  }

  void emitTo<T>(EventId<T> eventId, {required String targetPageId, required T payload}) {
    final key = _key(eventId, targetPageId: targetPageId);
    final controller = _controllers[key];
    controller?.add(payload);
  }
}

