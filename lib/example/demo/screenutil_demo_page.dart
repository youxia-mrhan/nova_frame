import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/foundation/logger/nova_logger.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/shared/util/toast_util.dart';

abstract final class ScreenUtilDemoRt {
  ScreenUtilDemoRt._();

  static const String path = '/demo/screen_util';
  static const String description = 'ScreenUtil 封装 Demo';
}

@NovaRoute(path: ScreenUtilDemoRt.path, description: ScreenUtilDemoRt.description)
@RoutePage()
class ScreenUtilDemoPage extends NovaPageShell {
  const ScreenUtilDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    final a = 12.dp;
    final b = 14.fs;
    final c = 12.rd;

    return Scaffold(
      appBar: AppBar(title: const Text('ScreenUtil Demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200.dp,
              height: 80.dp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.rd),
                border: Border.all(color: Colors.blueGrey.shade200),
              ),
              child: Text('12.dp / 14.fs / 12.rd', style: TextStyle(fontSize: 14.fs)),
            ),
            SizedBox(height: 16.dp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.dp),
              child: FilledButton(
                onPressed: () {
                  NovaLogger.d('12.dp = $a');
                  NovaLogger.d('14.fs = $b');
                  NovaLogger.d('12.rd = $c');
                  ToastUtil.show(
                    'test: 12.dp=$a, 14.fs=$b, 12.rd=$c',
                    context: context,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
                child: const Text('执行 test()'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
