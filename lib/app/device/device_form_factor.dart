import 'package:flutter/widgets.dart';

/// 设备形态（用于页面适配）
enum DeviceFormFactor {
  /// 手机（默认）
  phone,

  /// 平板
  pad,

  /// 折叠屏/双屏
  foldable,
}

/// 设备形态识别工具。
///
/// 规则
/// - foldable：判断 `MediaQuery.displayFeatures`
/// - pad：使用 `shortestSide >= 600`
/// - 其余为 phone。
class DeviceFormFactorUtil {
  DeviceFormFactorUtil._();

  static const double _padShortestSideThreshold = 600;

  static DeviceFormFactor of(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.displayFeatures.isNotEmpty) {
      return DeviceFormFactor.foldable;
    }
    if (mq.size.shortestSide >= _padShortestSideThreshold) {
      return DeviceFormFactor.pad;
    }
    return DeviceFormFactor.phone;
  }
}

