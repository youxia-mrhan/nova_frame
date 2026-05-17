import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/navigation/link/nova_link_scheme.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/protocol/route_navigation.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/util/toast_util.dart';
import '../router_demo/entity/demo_user_entity.dart';
import 'fake_push_link_entity_params_page.dart';
import 'fake_push_link_primitive_params_page.dart';

abstract final class FakePushLinkRt {
  FakePushLinkRt._();

  static const String path = '/demo/fake_push_link';
  static const String description = 'Fake Push / 深链栈对照';
}

@NovaRoute(path: FakePushLinkRt.path, description: FakePushLinkRt.description)
@RoutePage()
class FakePushLinkDemoPage extends NovaPageShell {
  const FakePushLinkDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    final origin = NovaLinkScheme.origin();
    final adbPrimitive =
        'adb shell "am start -a android.intent.action.VIEW -d \'$origin?path=%2Fdemo%2Ffake_push_link_primitive&title=from_adb&count=2\' com.youxia.nova_frame"';
    final adbEntity =
        'adb shell "am start -a android.intent.action.VIEW -d \'$origin?path=%2Fdemo%2Ffake_push_link_entity&payload=%7B%22id%22%3A%22plink%22%2C%22name%22%3A%22adb%22%2C%22age%22%3A1%7D\' com.youxia.nova_frame"';
    final iosPrimitive = 'xcrun simctl openurl booted \'$origin?path=%2Fdemo%2Ffake_push_link_primitive&title=from_adb&count=2\'';
    final iosEntity =
        'xcrun simctl openurl booted \'$origin?path=%2Fdemo%2Ffake_push_link_entity&payload=%7B%22id%22%3A%22plink%22%2C%22name%22%3A%22adb%22%2C%22age%22%3A1%7D\'';

    void copyCommand(String command) {
      Clipboard.setData(ClipboardData(text: command));
      ToastUtil.show(
        '已复制到剪贴板',
        context: context,
        gravity: ToastGravity.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }

    Widget commandBlock(String subtitle, String command) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: TextStyle(fontSize: 13.fs, color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 6.dp),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10.rd),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12.dp, 10.dp, 4.dp, 10.dp),
                    child: SelectableText(
                      command,
                      style: TextStyle(fontSize: 12.fs, height: 1.35, fontFamily: 'monospace'),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '复制',
                  icon: Icon(Icons.copy_rounded, size: 22.dp),
                  onPressed: () => copyCommand(command),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Fake Push / 深链栈')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '下面两个入口用于在「深链 / Push」场景下验证 query 参数：'
              '基础类型与实体（JSON payload）。',
            ),
            SizedBox(height: 16.dp),
            FilledButton(
              onPressed: () => context.push(
                path: FakePushLinkPrimitiveRt.path,
                query: <String, dynamic>{'title': 'from_push_link', 'count': 2},
              ),
              child: const Text('打开 A：基础类型参数'),
            ),
            SizedBox(height: 8.dp),
            FilledButton(
              onPressed: () {
                const user = DemoUserEntity(id: 'plink', name: 'PushLink', age: 1);
                context.push(path: FakePushLinkEntityRt.path, query: <String, dynamic>{'payload': user.toJson()});
              },
              child: const Text('打开 B：实体参数'),
            ),
            SizedBox(height: 24.dp),
            Text('Android adb 测试命令', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.fs)),
            SizedBox(height: 4.dp),
            Text(
              'URL 中含 & 时：adb shell 用双引号包住，-d 后的 URL 用单引号包住。',
              style: TextStyle(fontSize: 12.fs, color: theme.colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: 12.dp),
            commandBlock('基础类型（primitive）', adbPrimitive),
            SizedBox(height: 12.dp),
            commandBlock('实体（entity + payload）', adbEntity),
            SizedBox(height: 24.dp),
            Text('iOS xcrun 测试命令', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.fs)),
            SizedBox(height: 4.dp),
            Text(
              '模拟器需已 boot；URL 用单引号包住以免 & 被 shell 截断。',
              style: TextStyle(fontSize: 12.fs, color: theme.colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: 12.dp),
            commandBlock('基础类型（primitive）', iosPrimitive),
            SizedBox(height: 12.dp),
            commandBlock('实体（entity + payload）', iosEntity),
          ],
        ),
      ),
    );
  }
}
