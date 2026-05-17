import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/device/device_form_factor.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import 'entity/demo_user_entity.dart';

abstract final class EntStatefulRt {
  EntStatefulRt._();
  static const String path = '/demo/entity_stateful';
  static const String description = 'Router Demo · 实体参数（Stateful）';
}

/// 实体参数 Demo（Stateful）：NovaStatefulPageShell + setState
@NovaRoute(path: EntStatefulRt.path, description: EntStatefulRt.description)
@RoutePage()
class EntityParamsAdaptiveStatefulDemoPage extends NovaStatefulPageShell {
  const EntityParamsAdaptiveStatefulDemoPage({
    super.key,
    @QueryParam('payload') this.payload,
  });

  final String? payload;

  @override
  State<EntityParamsAdaptiveStatefulDemoPage> createState() => _EntityParamsAdaptiveStatefulDemoPageState();
}

class _EntityParamsAdaptiveStatefulDemoPageState extends NovaStatefulPageShellState<EntityParamsAdaptiveStatefulDemoPage> {

  @override
  Widget buildPhone(BuildContext context) => _build(context, DeviceFormFactor.phone);

  @override
  Widget buildPad(BuildContext context) => _build(context, DeviceFormFactor.pad);

  @override
  Widget buildFoldable(BuildContext context) => _build(context, DeviceFormFactor.foldable);

  Widget _build(BuildContext context, DeviceFormFactor branch) {
    final raw = widget.payload ?? '';
    final decoded = raw.isEmpty ? '' : Uri.decodeComponent(raw);
    final userEntity =
        raw.isEmpty ? const DemoUserEntity(id: '', name: '', age: 0) : DemoUserEntityPayloadX.fromPayload(raw);

    return Scaffold(
      appBar: AppBar(title: const Text('实体参数 Demo（NovaStatefulPageShell）')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DeviceFormFactorUtil.of: ${DeviceFormFactorUtil.of(context).name}'),
            SizedBox(height: 8.dp),
            Text('当前 build 分支：${branch.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 12.dp),
            Text('payload(decoded)：$decoded'),
            SizedBox(height: 12.dp),
            Text('解析到的实体：$userEntity'),
          ],
        ),
      ),
    );
  }
}

