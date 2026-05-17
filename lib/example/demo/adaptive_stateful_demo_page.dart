import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/device/device_form_factor.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';

abstract final class AdaptiveStatefulDemoRt {
  AdaptiveStatefulDemoRt._();
  static const String path = '/demo/adaptive_stateful';
  static const String description = 'NovaStatefulPageShell Demo';
}

@NovaRoute(path: AdaptiveStatefulDemoRt.path, description: AdaptiveStatefulDemoRt.description)
@RoutePage()
class AdaptiveStatefulDemoPage extends NovaStatefulPageShell {
  const AdaptiveStatefulDemoPage({super.key});

  @override
  State<AdaptiveStatefulDemoPage> createState() => _AdaptiveStatefulDemoPageState();
}

class _AdaptiveStatefulDemoPageState extends NovaStatefulPageShellState<AdaptiveStatefulDemoPage> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _count = 1;
  }

  @override
  Widget buildPhone(BuildContext context) {
    return _DemoScaffold(
      title: 'phone（Stateful）',
      color: Colors.orange,
      count: _count,
      body: const Text('这是 Phone 的 buildPhone 分支'),
    );
  }

  @override
  Widget buildPad(BuildContext context) {
    return _DemoScaffold(
      title: 'pad（Stateful）',
      color: Colors.blue,
      count: _count,
      body: const Text('这是 Pad 的 buildPad 分支'),
    );
  }

  @override
  Widget buildFoldable(BuildContext context) {
    final mq = MediaQuery.of(context);
    return _DemoScaffold(
      title: 'foldable（Stateful）',
      color: Colors.purple,
      count: _count,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('这是 Foldable 的 buildFoldable 分支'),
          SizedBox(height: 8.dp),
          Text('displayFeatures: ${mq.displayFeatures.length}'),
        ],
      ),
    );
  }

}

class _DemoScaffold extends StatelessWidget {
  const _DemoScaffold({
    required this.title,
    required this.color,
    required this.count,
    required this.body,
  });

  final String title;
  final Color color;
  final int count;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final factor = DeviceFormFactorUtil.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('NovaStatefulPageShell Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('识别结果：${factor.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 8.dp),
            Text('size: ${mq.size.width.toStringAsFixed(0)} x ${mq.size.height.toStringAsFixed(0)}'),
            SizedBox(height: 8.dp),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.dp),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.rd),
                border: Border.all(color: color.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('当前分支：$title', style: TextStyle(color: color, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8.dp),
                  body,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

