import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';

abstract final class FakePushLinkPrimitiveRt {
  FakePushLinkPrimitiveRt._();

  static const String path = '/demo/fake_push_link_primitive';
  static const String description = 'Fake Push · 基础类型参数';
}

@NovaRoute(path: FakePushLinkPrimitiveRt.path, description: FakePushLinkPrimitiveRt.description)
@RoutePage()
class FakePushLinkPrimitiveParamsPage extends NovaPageShell {
  const FakePushLinkPrimitiveParamsPage({super.key, @QueryParam('title') this.title, @QueryParam('count') this.count});

  final String? title;
  final int? count;

  @override
  Widget buildPhone(BuildContext context) {
    final params = <String, Object?>{'title': title, 'count': count};
    return Scaffold(
      appBar: AppBar(title: const Text('Fake Push · 基础类型参数')),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const Text('通过 URI query 解析到的参数：'), SizedBox(height: 8.dp), Text('$params')],
        ),
      ),
    );
  }
}
