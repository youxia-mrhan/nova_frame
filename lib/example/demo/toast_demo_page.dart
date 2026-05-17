import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/util/toast_util.dart';

abstract final class ToastDemoRt {
  ToastDemoRt._();

  static const String path = '/demo/toast';
  static const String description = 'Toast Demo';
}

@NovaRoute(path: ToastDemoRt.path, description: ToastDemoRt.description)
@RoutePage()
class ToastDemoPage extends NovaPageShell {
  const ToastDemoPage({super.key});

  void _show(BuildContext context, String msg, ToastGravity gravity) {
    // ToastUtil.show(msg, context: context, gravity: gravity);
    ToastUtil.show(msg, gravity: gravity);
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toast Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Text(
            'Toast 基于 fluttertoast 的 FToast。\n'
            '说明：这是 Overlay 级别提示，不依赖当前页面 context（内部会取全局 context）。',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.dp),
          FilledButton(onPressed: () => _show(context, '居中 Toast', ToastGravity.CENTER), child: const Text('居中显示')),
          SizedBox(height: 12.dp),
          FilledButton(onPressed: () => _show(context, '底部 Toast', ToastGravity.BOTTOM), child: const Text('底部显示')),
          SizedBox(height: 12.dp),
          FilledButton(onPressed: () => _show(context, '顶部 Toast', ToastGravity.TOP), child: const Text('顶部显示')),
          SizedBox(height: 12.dp),
          FilledButton.tonal(
            onPressed: () => ToastUtil.show(
              '自定义时长 1.2s（底部）',
              context: context,
              gravity: ToastGravity.BOTTOM,
              duration: const Duration(milliseconds: 1200),
            ),
            child: const Text('自定义时长'),
          ),
        ],
      ),
    );
  }
}
