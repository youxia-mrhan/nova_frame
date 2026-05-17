import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/device/device_form_factor.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';

abstract final class DeviceFormFactorDemoRt {
  DeviceFormFactorDemoRt._();
  static const String path = '/demo/device_form_factor';
  static const String description = '设备形态适配 Demo';
}

@NovaRoute(path: DeviceFormFactorDemoRt.path, description: DeviceFormFactorDemoRt.description)
@RoutePage()
class DeviceFormFactorDemoPage extends NovaPageShell {
  const DeviceFormFactorDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return _DemoScaffold(
      title: 'phone',
      color: Colors.orange,
      body: const Text('这是 Phone 布局'),
    );
  }

  @override
  Widget buildPad(BuildContext context) {
    return _DemoScaffold(
      title: 'pad',
      color: Colors.blue,
      body: const Text('这是 Pad 布局'),
    );
  }

  @override
  Widget buildFoldable(BuildContext context) {
    final mq = MediaQuery.of(context);
    return _DemoScaffold(
      title: 'foldable',
      color: Colors.purple,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('这是 Foldable 布局'),
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
    required this.body,
  });

  final String title;
  final Color color;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final factor = DeviceFormFactorUtil.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('设备形态 Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('识别结果：${factor.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 8.dp),
            Text('size: ${mq.size.width.toStringAsFixed(0)} x ${mq.size.height.toStringAsFixed(0)}'),
            SizedBox(height: 12.dp),
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

