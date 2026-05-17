import 'package:flutter/material.dart';

import 'custom_dialog_util.dart';

/// 从底部唤醒的，贴底半屏弹窗
///   高度：固定高度与「占屏高比例」二选一
sealed class BottomSheetDialogHeight {
  const BottomSheetDialogHeight._();

  /// 固定高度（逻辑像素）。
  const factory BottomSheetDialogHeight.fixed(double height) = _BottomSheetDialogHeightFixed;

  /// 占当前屏幕高度的比例，例如 `0.45` 表示 45% 屏高。
  const factory BottomSheetDialogHeight.screenFraction(double fraction) =
      _BottomSheetDialogHeightScreenFraction;

  double resolve(double screenHeight);
}

final class _BottomSheetDialogHeightFixed extends BottomSheetDialogHeight {
  const _BottomSheetDialogHeightFixed(this.height) : assert(height > 0), super._();
  final double height;

  @override
  double resolve(double screenHeight) => height;
}

final class _BottomSheetDialogHeightScreenFraction extends BottomSheetDialogHeight {
  const _BottomSheetDialogHeightScreenFraction(this.fraction)
      : assert(fraction > 0 && fraction <= 1),
        super._();
  final double fraction;

  @override
  double resolve(double screenHeight) => screenHeight * fraction;
}

/// 贴底 Bottom sheet 容器：宽度铺满，仅左上/右上圆角，高度由 [height] 决定。
///
/// 通常配合 [BottomSheetDialog.show]；也可在 [CustomDialogUtil.showCustomDialog] 的 [builder] 中直接使用。
class BottomSheetDialog extends StatelessWidget {
  const BottomSheetDialog({
    super.key,
    required this.height,
    required this.child,
    this.topLeftRadius,
    this.topRightRadius,
    this.backgroundColor,
    this.padding,
    this.applySafeAreaBottom = true,
    this.clipBehavior = Clip.antiAlias,
  });

  final BottomSheetDialogHeight height;
  final Widget child;

  /// 左上圆角；为 null 时使用 [defaultTopCornerRadius]。
  final double? topLeftRadius;

  /// 右上圆角；为 null 时使用 [defaultTopCornerRadius]。
  final double? topRightRadius;

  static const double defaultTopCornerRadius = 16;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool applySafeAreaBottom;
  final Clip clipBehavior;

  /// 左上/右上使用同一圆角半径。
  factory BottomSheetDialog.uniformTopCorners({
    Key? key,
    required BottomSheetDialogHeight height,
    required Widget child,
    double? topCornerRadius,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    bool applySafeAreaBottom = true,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return BottomSheetDialog(
      key: key,
      height: height,
      topLeftRadius: topCornerRadius,
      topRightRadius: topCornerRadius,
      backgroundColor: backgroundColor,
      padding: padding,
      applySafeAreaBottom: applySafeAreaBottom,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required BottomSheetDialogHeight height,
    required Widget child,
    double? topLeftRadius,
    double? topRightRadius,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    bool applySafeAreaBottom = true,
    bool barrierDismissible = true,
    ThemeData? dialogTheme,
    Duration? transitionDuration,
    Curve? curve,
    Color? barrierColor,
  }) {
    return CustomDialogUtil.showCustomDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      dialogTheme: dialogTheme,
      animationType: CustomDialogAnimationType.slideFromBottom,
      transitionDuration: transitionDuration,
      curve: curve,
      barrierColor: barrierColor,
      builder: (ctx) => BottomSheetDialog(
        height: height,
        topLeftRadius: topLeftRadius,
        topRightRadius: topRightRadius,
        backgroundColor: backgroundColor,
        padding: padding,
        applySafeAreaBottom: applySafeAreaBottom,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final h = height.resolve(media.height);
    final tl = topLeftRadius ?? defaultTopCornerRadius;
    final tr = topRightRadius ?? defaultTopCornerRadius;
    final bg = backgroundColor ??
        Theme.of(context).dialogTheme.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHigh;

    Widget panel = ClipRRect(
      clipBehavior: clipBehavior,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
      ),
      child: Material(
        color: bg,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );

    panel = SizedBox(
      width: double.infinity,
      height: h,
      child: panel,
    );

    if (applySafeAreaBottom) {
      panel = SafeArea(top: false, left: false, right: false, child: panel);
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: panel,
      ),
    );
  }
}
