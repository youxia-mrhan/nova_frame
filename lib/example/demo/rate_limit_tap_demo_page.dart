import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/action/widget/rate_limit_tap.dart';
import '../../core/shared/box/adapt.dart';

abstract final class RateLimitTapDemoRt {
  RateLimitTapDemoRt._();

  static const String path = '/demo/rate_limit_tap';
  static const String description = 'RateLimitTap Demo';
}

@NovaRoute(path: RateLimitTapDemoRt.path, description: RateLimitTapDemoRt.description)
@RoutePage()
class RateLimitTapDemoPage extends NovaStatefulPageShell {
  const RateLimitTapDemoPage({super.key});

  @override
  State<RateLimitTapDemoPage> createState() => _RateLimitTapDemoPageState();
}

class _RateLimitTapDemoPageState extends NovaStatefulPageShellState<RateLimitTapDemoPage> {
  int _rawCount = 0;
  int _throttleCount = 0;
  int _debounceCount = 0;

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RateLimitTap Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Text(
            '快速连续点击按钮，观察计数变化：\n'
            '- Raw：每次都会触发\n'
            '- Throttle：500ms 内只触发第一次\n'
            '- Debounce：500ms 内只触发最后一次',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.dp),
          _CounterCard(
            title: 'Raw（无防抖/节流）',
            count: _rawCount,
            child: FilledButton(onPressed: () => setState(() => _rawCount++), child: const Text('连续点我')),
          ),
          SizedBox(height: 12.dp),
          _CounterCard(
            title: 'Throttle（节流）',
            subtitle: 'useThrottle=true, throttleMs=500',
            count: _throttleCount,
            child: RateLimitTap(
              useThrottle: true,
              throttleMs: 500,
              child: IgnorePointer(
                child: FilledButton(onPressed: () {}, child: const Text('连续点我')),
              ),
              onTap: () => setState(() => _throttleCount++),
            ),
          ),
          SizedBox(height: 12.dp),
          _CounterCard(
            title: 'Debounce（防抖）',
            subtitle: 'useThrottle=false, debounceMs=500',
            count: _debounceCount,
            child: RateLimitTap(
              useThrottle: false,
              debounceMs: 500,
              child: IgnorePointer(
                child: FilledButton(onPressed: () {}, child: const Text('连续点我')),
              ),
              onTap: () => setState(() => _debounceCount++),
            ),
          ),
          SizedBox(height: 16.dp),
          FilledButton.tonal(
            onPressed: () => setState(() {
              _rawCount = 0;
              _throttleCount = 0;
              _debounceCount = 0;
            }),
            child: const Text('重置计数'),
          ),
        ],
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({required this.title, this.subtitle, required this.count, required this.child});

  final String title;
  final String? subtitle;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            if (subtitle != null) ...[SizedBox(height: 6.dp), Text(subtitle!, style: theme.textTheme.bodySmall)],
            SizedBox(height: 12.dp),
            Text('count = $count', style: theme.textTheme.bodyMedium),
            SizedBox(height: 12.dp),
            child,
          ],
        ),
      ),
    );
  }
}
