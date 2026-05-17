import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/device/device_form_factor.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';

abstract final class PrimStatefulRt {
  PrimStatefulRt._();
  static const String path = '/demo/primitive_stateful';
  static const String description = 'Router Demo · 基础类型参数（Stateful）';
}

/// 基础类型参数 Demo（Stateful）：NovaStatefulPageShell + setState
@NovaRoute(path: PrimStatefulRt.path, description: PrimStatefulRt.description)
@RoutePage()
class PrimitiveParamsAdaptiveStatefulDemoPage extends NovaStatefulPageShell {
  const PrimitiveParamsAdaptiveStatefulDemoPage({
    super.key,
    @QueryParam('title') this.title,
    @QueryParam('count') this.count,
  });

  final String? title;
  final int? count;

  @override
  State<PrimitiveParamsAdaptiveStatefulDemoPage> createState() => _PrimitiveParamsAdaptiveStatefulDemoPageState();
}

class _PrimitiveParamsAdaptiveStatefulDemoPageState
    extends NovaStatefulPageShellState<PrimitiveParamsAdaptiveStatefulDemoPage> {

  @override
  Widget buildPhone(BuildContext context) => _build(context, DeviceFormFactor.phone);

  @override
  Widget buildPad(BuildContext context) => _build(context, DeviceFormFactor.pad);

  @override
  Widget buildFoldable(BuildContext context) => _build(context, DeviceFormFactor.foldable);

  Widget _build(BuildContext context, DeviceFormFactor branch) {
    return _Scaffold(
      branch: branch,
      title: widget.title ?? '',
      count: widget.count ?? 0,
    );
  }

}

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    required this.branch,
    required this.title,
    required this.count,
  });

  final DeviceFormFactor branch;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final factor = DeviceFormFactorUtil.of(context);
    final params = <String, Object?>{'title': title, 'count': count};
    return Scaffold(
      appBar: AppBar(title: const Text('基础类型参数 Demo（NovaStatefulPageShell）')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DeviceFormFactorUtil.of: ${factor.name}'),
            SizedBox(height: 8.dp),
            Text('当前 build 分支：${branch.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 12.dp),
            Text('解析到的参数：$params'),
          ],
        ),
      ),
    );
  }
}

