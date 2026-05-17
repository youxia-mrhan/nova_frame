import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import '../router_demo/entity/demo_user_entity.dart';

abstract final class FakePushLinkEntityRt {
  FakePushLinkEntityRt._();

  static const String path = '/demo/fake_push_link_entity';
  static const String description = 'Fake Push · 实体参数';
}

@NovaRoute(path: FakePushLinkEntityRt.path, description: FakePushLinkEntityRt.description)
@RoutePage()
class FakePushLinkEntityParamsPage extends NovaPageShell {
  const FakePushLinkEntityParamsPage({super.key, @QueryParam('payload') this.payload});

  final String? payload;

  @override
  Widget buildPhone(BuildContext context) {
    final raw = payload ?? '';
    final decoded = raw.isEmpty ? '' : Uri.decodeComponent(raw);
    final userEntity = raw.isEmpty
        ? const DemoUserEntity(id: '', name: '', age: 0)
        : DemoUserEntityPayloadX.fromPayload(raw);

    return Scaffold(
      appBar: AppBar(title: const Text('Fake Push · 实体参数')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('payload（decode 后展示）：'),
            SizedBox(height: 8.dp),
            Text(decoded.isEmpty ? '（空）' : decoded),
            SizedBox(height: 16.dp),
            Text('解析实体：$userEntity'),
          ],
        ),
      ),
    );
  }
}
