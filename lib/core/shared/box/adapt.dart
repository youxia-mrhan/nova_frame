import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nova_frame/app/device/device_form_factor.dart';
import 'package:nova_frame/core/shared/box/app_design_size.dart';

/// 根节点屏幕适配：按设备形态切换全局 [AppDesignSize] 设计稿。
///
/// 手机 / iPad 竖横屏 / 折叠屏使用事先定义的尺寸；
/// 形态变化时通过 [ValueKey] 重新 init。
class ScreenAdaptInit extends StatelessWidget {
  const ScreenAdaptInit({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.maybeOf(context) ?? MediaQueryData.fromView(View.of(context));
    final factor = DeviceFormFactorUtil.fromMediaQuery(mq);
    final designSize = AppDesignSize.of(factor);

    return ScreenUtilInit(
      key: ValueKey('${designSize.width}x${designSize.height}'),
      designSize: designSize,
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, childWidget) => child,
      child: child,
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
