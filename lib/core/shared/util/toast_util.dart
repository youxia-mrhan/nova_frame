import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../navigation/nova_navigator_context.dart';
import '../box/adapt.dart';

/// Toast 提示工具类
class ToastUtil {
  ToastUtil._();

  static final FToast _fToast = FToast();

  static void init(BuildContext context) {
    _fToast.init(context);
  }

  static void show(
    String msg, {
    BuildContext? context,
    ToastGravity gravity = ToastGravity.CENTER,
    Duration duration = const Duration(seconds: 3),
  }) {
    final ctx = context ?? NovaNavigatorContext.context;
    if (ctx == null) return;

    final media = MediaQuery.of(ctx);
    final child = _buildToast(ctx, msg, media.size.width);

    _fToast.showToast(child: child, gravity: gravity, toastDuration: duration, ignorePointer: true);
  }

  static Widget _buildToast(BuildContext context, String msg, double screenWidth) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600);

    return SizedBox(
      width: screenWidth,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.dp, vertical: 12.dp),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.rd), color: const Color(0xE5000000)),
          child: Text(msg, style: textStyle, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
