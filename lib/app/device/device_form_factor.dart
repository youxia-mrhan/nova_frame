import 'package:flutter/widgets.dart';

/// 设备形态（用于页面适配）
enum DeviceFormFactor {
  /// 手机（默认）
  phone,

  /// 平板竖屏
  pad,

  /// 平板横屏
  padLandscape,

  /// 折叠屏/双屏
  foldable,
}

/// 设备形态识别工具。
///
/// 规则
/// - foldable：判断 `MediaQuery.displayFeatures`
/// - pad / padLandscape：`shortestSide >= 600`，横竖屏由宽高判断
/// - 其余为 phone。
class DeviceFormFactorUtil {
  DeviceFormFactorUtil._();

  static const double _padShortestSideThreshold = 600;

  static DeviceFormFactor of(BuildContext context) {
    return fromMediaQuery(MediaQuery.of(context));
  }

  static DeviceFormFactor fromMediaQuery(MediaQueryData mq) {
    if (mq.displayFeatures.isNotEmpty) {
      return DeviceFormFactor.foldable;
    }
    if (mq.size.shortestSide >= _padShortestSideThreshold) {
      return mq.size.width > mq.size.height ? DeviceFormFactor.padLandscape : DeviceFormFactor.pad;
    }
    return DeviceFormFactor.phone;
  }
}
