import 'package:flutter/material.dart';

import '../../navigation/nova_router.dart';

/// 自定义弹窗基类，支持多种进入/退出动画。
class CustomDialogUtil {
  CustomDialogUtil._();

  /// 默认遮罩：约 40% 透明黑（与 `Color(0x66000000)` 一致）。
  static const Color defaultBarrierColor = Color(0x66000000);

  static Future<T?> showCustomDialog<T>({
    required BuildContext context,

    /// 一个参数同时控制：
    /// - 点击遮罩是否可关闭（dismiss）
    /// - 系统返回键/手势返回是否允许 pop
    ///
    /// 若不传，则兼容旧参数 [barrierDismissible] 的行为（仅控制遮罩点击）。
    bool? dismissible,
    bool barrierDismissible = false,
    required WidgetBuilder builder,

    /// 弹窗内容使用的主题；不传则继承当前 [Theme.of(context)]。
    ThemeData? dialogTheme,
    CustomDialogAnimationType? animationType,
    Duration? transitionDuration,
    Curve? curve,
    Color? barrierColor,
  }) {
    final allowPop = dismissible ?? true;
    final effectiveBarrierDismissible = dismissible ?? barrierDismissible;
    final effectiveTheme = dialogTheme ?? Theme.of(context);
    return showGeneralDialog<T>(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        Widget pageChild = Builder(builder: builder);
        if (!allowPop) {
          pageChild = PopScope(canPop: false, child: pageChild);
        }
        return GestureDetector(
          onTap: effectiveBarrierDismissible ? () => novaRouter.maybePop() : null,
          child: MediaQuery.removePadding(
            context: buildContext,
            removeTop: true,
            removeBottom: true,
            child: Theme(data: effectiveTheme, child: pageChild),
          ),
        );
      },
      barrierDismissible: effectiveBarrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? defaultBarrierColor,
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _buildMaterialDialogTransitions(
          context: context,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          animationType: animationType,
          curve: curve,
          child: child,
        );
      },
    );
  }

  static Widget _buildMaterialDialogTransitions({
    required BuildContext context,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required CustomDialogAnimationType? animationType,
    required Widget child,
    Curve? curve,
  }) {
    final c = curve ?? Curves.easeInOut;
    switch (animationType) {
      case CustomDialogAnimationType.scale:
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: c),
          child: child,
        );
      case CustomDialogAnimationType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: c)),
          child: child,
        );
      case CustomDialogAnimationType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: c)),
          child: child,
        );
      case CustomDialogAnimationType.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: c)),
          child: child,
        );
      case null:
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: c),
          child: child,
        );
    }
  }
}

/// 弹窗进入/退出动画类型。
enum CustomDialogAnimationType {
  /// 缩放
  scale,

  /// 自左侧滑入/滑出
  slideFromLeft,

  /// 自下侧滑入/滑出
  slideFromBottom,

  /// 自上侧滑入/滑出
  slideFromTop,
}
