import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/device/device_form_factor.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import 'entity/demo_user_entity.dart';

abstract final class EntityRt {
  EntityRt._();
  static const String path = '/demo/entity';
  static const String description = 'Router Demo · 实体参数';
}

/// 实体参数 Demo：把实体转 JSON → urlEncode → 放到 query 里传递
@NovaRoute(path: EntityRt.path, description: EntityRt.description)
@RoutePage()
class EntityParamsDemoPage extends NovaPageShell {
  const EntityParamsDemoPage({
    super.key,
    @QueryParam('payload') this.payload,
  });

  /// 约定：payload 为 urlEncode 过的 json 字符串
  final String? payload;

  @override
  Widget buildPhone(BuildContext context) => _build(context, DeviceFormFactor.phone);

  @override
  Widget buildPad(BuildContext context) => _build(context, DeviceFormFactor.pad);

  @override
  Widget buildFoldable(BuildContext context) => _build(context, DeviceFormFactor.foldable);

  Widget _build(BuildContext context, DeviceFormFactor branch) {
    final raw = payload ?? '';
    final decoded = raw.isEmpty ? '' : Uri.decodeComponent(raw);
    final userEntity = raw.isEmpty ? const DemoUserEntity(id: '', name: '', age: 0) : DemoUserEntityPayloadX.fromPayload(raw);

    return _Scaffold(
      branch: branch,
      decoded: decoded,
      userEntity: userEntity,
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    required this.branch,
    required this.decoded,
    required this.userEntity,
  });

  final DeviceFormFactor branch;
  final String decoded;
  final DemoUserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    final factor = DeviceFormFactorUtil.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('实体参数 Demo（NovaPageShell）')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DeviceFormFactorUtil.of: ${factor.name}'),
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

