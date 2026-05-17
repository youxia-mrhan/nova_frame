import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/foundation/logger/nova_logger.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/eventbus/event_bus.dart';
import '../../core/shared/util/toast_util.dart';

abstract final class EventBusDemoRt {
  EventBusDemoRt._();

  static const String path = '/demo/eventbus';
  static const String description = 'EventBus Demo';
}

@NovaRoute(path: EventBusDemoRt.path, description: EventBusDemoRt.description)
@RoutePage()
class EventBusDemoPage extends NovaStatefulPageShell {
  const EventBusDemoPage({super.key});

  @override
  State<EventBusDemoPage> createState() => _EventBusDemoPageState();
}

class _EventBusDemoPageState extends NovaStatefulPageShellState<EventBusDemoPage> {
  static const String pageId = 'eventbus_demo_page';
  static const EventId<String> eventHello = EventId<String>('demo.hello');

  StreamSubscription<String>? _subBroadcast1;
  StreamSubscription<String>? _subBroadcast2;
  StreamSubscription<String>? _subTarget;

  void _toast(String msg) {
    NovaLogger.d(msg);
    if (!mounted) return;
    ToastUtil.show(msg, context: context, gravity: ToastGravity.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    _subBroadcast1 = EventBus.instance.on(eventHello).listen((payload) {
      if (!mounted) return;
      _toast('广播订阅1收到：$payload');
    });
    _subBroadcast2 = EventBus.instance.on(eventHello).listen((payload) {
      if (!mounted) return;
      _toast('广播订阅2收到：$payload');
    });
    _subTarget = EventBus.instance.onTarget(eventHello, targetPageId: pageId).listen((payload) {
      if (!mounted) return;
      _toast('定向订阅（target=$pageId）收到：$payload');
    });
  }

  @override
  void dispose() {
    _subBroadcast1?.cancel();
    _subBroadcast2?.cancel();
    _subTarget?.cancel();
    super.dispose();
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EventBus Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () => EventBus.instance.emit(eventHello, '来自按钮的广播消息'),
                child: const Text('一对多广播 emit'),
              ),
              SizedBox(height: 12.dp),
              FilledButton(
                onPressed: () =>
                    EventBus.instance.emitTo(eventHello, targetPageId: pageId, payload: '来自按钮的定向消息（应被本页收到）'),
                child: const Text('定向推送 emitTo（本页）'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
