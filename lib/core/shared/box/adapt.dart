import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 包装一层，如果flutter_screenutil框架停止维护，方便替换其他的适配方案
class ScreenAdaptInit extends StatelessWidget {
  const ScreenAdaptInit({
    super.key,
    required this.child,
    this.designSize = const Size(375, 812),
  });

  final Widget child;
  final Size designSize;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, childWidget) => child,
    );
  }
}

/// 所有缩放统一使用（`.w`），避免横屏时，按高度缩放带来的比例问题。
/// 使用 12.dp / 14.fs / 12.rd
extension DimensX on num {
  /// 宽/高
  double get dp => w;

  /// 字号
  double get fs => w;

  /// 圆角
  double get rd => w;

  /// 获取安全区域底部距离（如果有），否则返回 16.dp 的默认值，避免某些设备（如 iPhone）底部被遮挡。
  double safeBottomOr16Dp(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    return inset != 0 ? inset : 16.dp;
  }
}
