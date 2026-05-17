import 'package:flutter/material.dart';

import '../box/adapt.dart';
import 'custom_dialog_util.dart';

/// 居中弹窗：高度随内容；宽度按 **UI 稿的宽高比**（[designWidth] / [designHeight]）由内容高度推算，
/// 并受 [maxWidthFraction] 上限约束，减轻折叠屏等宽屏，把弹窗拉得过宽的问题。
///
/// 竖直方向受 [maxHeightFraction] 限制；若超出请在 [child] 内自行包 [SingleChildScrollView] 等。
class DesignAspectCenterDialog extends StatefulWidget {
  const DesignAspectCenterDialog({
    super.key,
    required this.designWidth,
    required this.designHeight,
    required this.child,
    this.borderRadius,
    this.backgroundColor,
    this.maxHeightFraction = 0.85,
    this.maxWidthFraction = 0.9,
    this.maxLayoutPasses = 6,
    this.clipBehavior = Clip.antiAlias,
  }) : assert(designWidth > 0),
       assert(designHeight > 0),
       assert(maxHeightFraction > 0 && maxHeightFraction <= 1),
       assert(maxWidthFraction > 0 && maxWidthFraction <= 1),
       assert(maxLayoutPasses >= 1);

  /// 注意：这两个参数仅用于计算宽高比，实际显示尺寸会受内容和 [maxHeightFraction]、[maxWidthFraction] 约束。

  /// UI 稿上弹窗宽度
  final double designWidth;

  /// UI 稿上弹窗高度。
  final double designHeight;

  final Widget child;

  final double? borderRadius;

  static double get defaultBorderRadius => 12.rd;

  final Color? backgroundColor;
  final double maxHeightFraction;
  final double maxWidthFraction;
  final int maxLayoutPasses;
  final Clip clipBehavior;

  double get _widthPerHeight => designWidth / designHeight;

  static Future<T?> show<T>({
    required BuildContext context,
    required double designWidth,
    required double designHeight,
    required Widget child,
    double? borderRadius,
    Color? backgroundColor,
    double maxHeightFraction = 0.85,
    double maxWidthFraction = 0.9,
    int maxLayoutPasses = 6,
    bool barrierDismissible = true,
    CustomDialogAnimationType? animationType,
    ThemeData? dialogTheme,
    Duration? transitionDuration,
    Curve? curve,
    Color? barrierColor,
  }) {
    return CustomDialogUtil.showCustomDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      dialogTheme: dialogTheme,
      animationType: animationType,
      transitionDuration: transitionDuration,
      curve: curve,
      barrierColor: barrierColor,
      builder: (ctx) => DesignAspectCenterDialog(
        designWidth: designWidth,
        designHeight: designHeight,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        maxHeightFraction: maxHeightFraction,
        maxWidthFraction: maxWidthFraction,
        maxLayoutPasses: maxLayoutPasses,
        child: child,
      ),
    );
  }

  @override
  State<DesignAspectCenterDialog> createState() => _DesignAspectCenterDialogState();
}

class _DesignAspectCenterDialogState extends State<DesignAspectCenterDialog> {
  final GlobalKey _measureKey = GlobalKey();
  double? _appliedWidth;
  int _passes = 0;

  @override
  void didUpdateWidget(covariant DesignAspectCenterDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.designWidth != widget.designWidth || oldWidget.designHeight != widget.designHeight) {
      _appliedWidth = null;
      _passes = 0;
    }
  }

  void _afterLayout() {
    if (!mounted) return;
    if (_passes >= widget.maxLayoutPasses) return;

    final box = _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final mq = MediaQuery.sizeOf(context);
    final maxW = mq.width * widget.maxWidthFraction;
    final h = box.size.height;
    final nextW = (h * widget._widthPerHeight).clamp(0.0, maxW);
    final currentW = _appliedWidth ?? maxW;

    if ((currentW - nextW).abs() <= 0.5) {
      if (_appliedWidth == null) {
        setState(() => _appliedWidth = nextW);
      }
      return;
    }

    setState(() {
      _appliedWidth = nextW;
      _passes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    final maxW = mq.width * widget.maxWidthFraction;
    final maxH = mq.height * widget.maxHeightFraction;
    final w = _appliedWidth ?? maxW;

    final bg = widget.backgroundColor ??
        Theme.of(context).dialogTheme.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHigh;

    WidgetsBinding.instance.addPostFrameCallback((_) => _afterLayout());

    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? DesignAspectCenterDialog.defaultBorderRadius),
          clipBehavior: widget.clipBehavior,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: w, maxHeight: maxH),
            child: SizedBox(
              width: w,
              child: KeyedSubtree(
                key: _measureKey,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
