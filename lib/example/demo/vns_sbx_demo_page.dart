import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/protocol/route_navigation.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/foundation/reactive/stream_state.dart';
import '../../core/foundation/reactive/multi_listen.dart';
import '../../core/foundation/reactive/value_state.dart';

abstract final class VnsSbxDemoRt {
  VnsSbxDemoRt._();

  static const String path = '/demo/vns_sbx';
  static const String description = 'Vns/Obx 与 Sns/Sbx 示例（入口）';
}

abstract final class VnsSbxBasicDemoRt {
  VnsSbxBasicDemoRt._();

  static const String path = '/demo/vns_sbx_basic';
  static const String description = 'Vns/Obx 与 Sns/Sbx：基础用法';
}

abstract final class VnsSbxMultiDemoRt {
  VnsSbxMultiDemoRt._();

  static const String path = '/demo/vns_sbx_multi';
  static const String description = '同时监听多个 Vns';
}

@NovaRoute(path: VnsSbxDemoRt.path, description: VnsSbxDemoRt.description)
@RoutePage()
class VnsSbxDemoPage extends NovaPageShell {
  const VnsSbxDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vns / Sbx 示例')),
      body: ListView(
        padding: EdgeInsets.all(24.dp),
        children: [
          SizedBox(height: 24.dp),
          FilledButton(
            onPressed: () => context.push(path: VnsSbxBasicDemoRt.path),
            child: const Text('A · Vns/Obx 与 Sns/Sbx 基础'),
          ),
          SizedBox(height: 12.dp),
          FilledButton.tonal(
            onPressed: () => context.push(path: VnsSbxMultiDemoRt.path),
            child: const Text('B · 同时监听多个 Vns'),
          ),
        ],
      ),
    );
  }
}

@NovaRoute(path: VnsSbxBasicDemoRt.path, description: VnsSbxBasicDemoRt.description)
@RoutePage()
class VnsSbxBasicDemoPage extends NovaStatefulPageShell {
  const VnsSbxBasicDemoPage({super.key});

  @override
  State<VnsSbxBasicDemoPage> createState() => _VnsSbxBasicDemoPageState();
}

class _VnsSbxBasicDemoPageState extends NovaStatefulPageShellState<VnsSbxBasicDemoPage> {
  static const int _snsMaxSeconds = 60;

  late final NovaNotifier<int> _counter;
  late final NovaStreamNotifier<int> _eventSns;
  Timer? _snsTimer;
  bool _snsRunning = false;
  int _snsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _counter = NovaNotifier(0);
    _eventSns = NovaStreamNotifier<int>();
    _eventSns.add(0);
  }

  void _cancelSnsTimer() {
    _snsTimer?.cancel();
    _snsTimer = null;
  }

  void _toggleSnsTimer() {
    if (_snsRunning) {
      _cancelSnsTimer();
      setState(() => _snsRunning = false);
      return;
    }
    if (_snsElapsed >= _snsMaxSeconds) return;

    setState(() => _snsRunning = true);
    _snsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_snsElapsed >= _snsMaxSeconds) {
        _cancelSnsTimer();
        setState(() => _snsRunning = false);
        return;
      }
      final next = _snsElapsed + 1;
      _eventSns.add(next);
      setState(() => _snsElapsed = next);
      if (next >= _snsMaxSeconds) {
        _cancelSnsTimer();
        setState(() => _snsRunning = false);
      }
    });
  }

  void _resetSnsTimer() {
    _cancelSnsTimer();
    setState(() {
      _snsRunning = false;
      _snsElapsed = 0;
    });
    _eventSns.add(0);
  }

  @override
  void dispose() {
    _cancelSnsTimer();
    if (!_counter.isDisposed) {
      _counter.dispose();
    }
    _eventSns.close();
    super.dispose();
  }

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Vns/Obx · Sns/Sbx 基础')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          _VnsObxPanel(counter: _counter, theme: theme),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.dp),
            child: Divider(height: 1.dp, color: theme.colorScheme.outlineVariant),
          ),
          _SnsSbxPanel(
            eventSns: _eventSns,
            theme: theme,
            isRunning: _snsRunning,
            elapsed: _snsElapsed,
            maxSeconds: _snsMaxSeconds,
            onToggleTimer: _toggleSnsTimer,
            onResetTimer: _resetSnsTimer,
          ),
        ],
      ),
    );
  }
}

@NovaRoute(path: VnsSbxMultiDemoRt.path, description: VnsSbxMultiDemoRt.description)
@RoutePage()
class VnsSbxMultiDemoPage extends NovaStatefulPageShell {
  const VnsSbxMultiDemoPage({super.key});

  @override
  State<VnsSbxMultiDemoPage> createState() => _VnsSbxMultiDemoPageState();
}

class _VnsSbxMultiDemoPageState extends NovaStatefulPageShellState<VnsSbxMultiDemoPage> {
  late final NovaNotifier<int> _va;
  late final NovaNotifier<int> _vb;
  late final NovaNotifier<int> _vc;
  late final Listenable _anyMerged;
  late final NovaAllDirtyGate _allGate;
  VoidCallback? _anyMergedListener;

  int _anyMergedNotifyCount = 0;
  int _allDirtyRoundCount = 0;

  @override
  void initState() {
    super.initState();
    _va = NovaNotifier(0);
    _vb = NovaNotifier(0);
    _vc = NovaNotifier(0);

    _anyMerged = novaAnyMerged(<Listenable>[_va, _vb, _vc]);
    _anyMergedListener = () {
      if (!mounted) return;
      setState(() => _anyMergedNotifyCount++);
    };
    _anyMerged.addListener(_anyMergedListener!);

    _allGate = NovaAllDirtyGate(
      <Listenable>[_va, _vb, _vc],
      onRoundComplete: () {
        if (!mounted) return;
        setState(() => _allDirtyRoundCount++);
      },
    );
  }

  @override
  void dispose() {
    if (_anyMergedListener != null) {
      _anyMerged.removeListener(_anyMergedListener!);
    }
    _allGate.dispose();
    super.dispose();
  }

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('多路监听 Vns')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          _VnsMultiListenPanel(
            theme: theme,
            va: _va,
            vb: _vb,
            vc: _vc,
            anyMergedNotifyCount: _anyMergedNotifyCount,
            allDirtyRoundCount: _allDirtyRoundCount,
            onBumpA: () => _va.value = _va.value + 1,
            onBumpB: () => _vb.value = _vb.value + 1,
            onBumpC: () => _vc.value = _vc.value + 1,
          ),
        ],
      ),
    );
  }
}

class _VnsMultiListenPanel extends StatelessWidget {
  const _VnsMultiListenPanel({
    required this.theme,
    required this.va,
    required this.vb,
    required this.vc,
    required this.anyMergedNotifyCount,
    required this.allDirtyRoundCount,
    required this.onBumpA,
    required this.onBumpB,
    required this.onBumpC,
  });

  final ThemeData theme;
  final NovaNotifier<int> va;
  final NovaNotifier<int> vb;
  final NovaNotifier<int> vc;
  final int anyMergedNotifyCount;
  final int allDirtyRoundCount;
  final VoidCallback onBumpA;
  final VoidCallback onBumpB;
  final VoidCallback onBumpC;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('同时监听 Vns 值', style: theme.textTheme.titleMedium),
        SizedBox(height: 8.dp),
        Text(
          '三个独立 Vns（a / b / c）',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.45),
        ),
        SizedBox(height: 16.dp),
        Row(
          children: [
            Expanded(
              child: NovaBuilder<int>(
                ls: va,
                autoDispose: true,
                bx: (ctx, v, _) => Text('a = $v', textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: NovaBuilder<int>(
                ls: vb,
                autoDispose: true,
                bx: (ctx, v, _) => Text('b = $v', textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: NovaBuilder<int>(
                ls: vc,
                autoDispose: true,
                bx: (ctx, v, _) => Text('c = $v', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.dp),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonal(onPressed: onBumpA, child: const Text('a +1')),
            ),
            SizedBox(width: 8.dp),
            Expanded(
              child: FilledButton.tonal(onPressed: onBumpB, child: const Text('b +1')),
            ),
            SizedBox(width: 8.dp),
            Expanded(
              child: FilledButton.tonal(onPressed: onBumpC, child: const Text('c +1')),
            ),
          ],
        ),
        SizedBox(height: 16.dp),
        Text('只要有一个 vns 值发生改变，就触发通知，累加次数：$anyMergedNotifyCount', style: TextStyle(fontSize: 12.fs)),
        SizedBox(height: 16.dp),
        Text('只有所有 vns 值都发生过改变，才会触发一轮通知，累加次数：$allDirtyRoundCount', style: TextStyle(fontSize: 12.fs)),
      ],
    );
  }
}

class _VnsObxPanel extends StatelessWidget {
  const _VnsObxPanel({required this.counter, required this.theme});

  final NovaNotifier<int> counter;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Vns + Obx（同步执行）', style: theme.textTheme.titleMedium),
        SizedBox(height: 8.dp),
        Text('由 ValueNotifier 封装。', style: theme.textTheme.bodyMedium),
        SizedBox(height: 6.dp),
        Text(
          '应用场景：监听某一个值，实现局部刷新。',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: 16.dp),
        NovaBuilder<int>(
          ls: counter,
          autoDispose: true,
          bx: (ctx, v, cd) => Text('count = $v', style: theme.textTheme.headlineSmall),
        ),
        SizedBox(height: 12.dp),
        FilledButton(onPressed: () => counter.value = counter.value + 1, child: const Text('Button（+1）')),
      ],
    );
  }
}

class _SnsSbxPanel extends StatelessWidget {
  const _SnsSbxPanel({
    required this.eventSns,
    required this.theme,
    required this.isRunning,
    required this.elapsed,
    required this.maxSeconds,
    required this.onToggleTimer,
    required this.onResetTimer,
  });

  final NovaStreamNotifier<int> eventSns;
  final ThemeData theme;
  final bool isRunning;
  final int elapsed;
  final int maxSeconds;
  final VoidCallback onToggleTimer;
  final VoidCallback onResetTimer;

  @override
  Widget build(BuildContext context) {
    final atCap = elapsed >= maxSeconds && !isRunning;
    final canStart = !isRunning && elapsed < maxSeconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Sns + Sbx（异步执行）', style: theme.textTheme.titleMedium),
        SizedBox(height: 8.dp),
        Text('由 Stream 封装。', style: theme.textTheme.bodyMedium),
        SizedBox(height: 6.dp),
        Text(
          '应用场景：监听一个连续的事件，实现局部刷新。',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: 8.dp),
        Text(
          '定时器每秒向流 add 当前秒数，0～$maxSeconds；开始/暂停；到达 $maxSeconds 自动停；重置归零。',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: 16.dp),
        NovaStreamBox<int>(
          stream: eventSns.stream,
          notifier: eventSns,
          autoDispose: true,
          seed: 0,
          builder: (ctx, snap, cd) {
            final v = snap.data;
            return Text(v == null ? 'count = …' : 'count = $v / $maxSeconds', style: theme.textTheme.headlineSmall);
          },
        ),
        SizedBox(height: 12.dp),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: isRunning ? onToggleTimer : (canStart ? onToggleTimer : null),
                child: Text(isRunning ? '暂停' : (atCap ? '已达 $maxSeconds 秒' : '开始')),
              ),
            ),
            SizedBox(width: 12.dp),
            Expanded(
              child: OutlinedButton(onPressed: onResetTimer, child: const Text('重置')),
            ),
          ],
        ),
        SizedBox(height: 8.dp),
        Text(
          '定时器在页面 dispose 中取消；Sns 在 dispose 中 close。',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
