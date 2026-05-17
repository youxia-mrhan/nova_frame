import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../util/toast_util.dart';

/// 根页面双击返回退出（Android 常用）。
class DoubleTapExit extends StatefulWidget {
  const DoubleTapExit({
    super.key,
    required this.child,
    this.exitMessage = '再按一次退出应用',
    this.interval = const Duration(seconds: 2),
    this.exitApp = true,
  });

  final Widget child;
  final String exitMessage;
  final Duration interval;

  /// 是否真的退出 App；否则仅拦截返回并提示。
  final bool exitApp;

  @override
  State<DoubleTapExit> createState() => _DoubleTapExitState();
}

class _DoubleTapExitState extends State<DoubleTapExit> {
  DateTime? _lastPressed;

  void _showToast() {
    ToastUtil.show(widget.exitMessage, context: context, gravity: ToastGravity.BOTTOM);
  }

  bool _shouldExitNow() {
    final now = DateTime.now();
    if (_lastPressed == null || now.difference(_lastPressed!) > widget.interval) {
      _lastPressed = now;
      _showToast();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // iOS 上一般不做“返回键退出”，这里默认只对 Android 生效。
    final enabled = Platform.isAndroid;

    return PopScope(
      canPop: !enabled,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!enabled) return;

        if (_shouldExitNow()) {
          if (!widget.exitApp) return;
          // 优先走系统退出；若无效再强制 exit（极少数 ROM）。
          await SystemNavigator.pop();
          exit(0);
        }
      },
      child: widget.child,
    );
  }
}
