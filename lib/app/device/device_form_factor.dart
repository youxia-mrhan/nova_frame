import 'dart:math';
import 'dart:ui' show DisplayFeatureType;

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
/// 与 [AppDesignSize] 设计稿一一对应，按「宽高比 + 短边」与当前窗口做最近邻匹配；
/// 横竖屏先过滤候选（竖屏不含 [DeviceFormFactor.padLandscape]）。
///
/// - foldable 仅在有 `hinge` / `fold` 的 [DisplayFeature] 时参与候选（忽略 `cutout` 刘海）
/// - 短边 < 600 时固定为 phone（与常见平板阈值一致）
class DeviceFormFactorUtil {
  DeviceFormFactorUtil._();

  static const double _padShortestSideThreshold = 600;
  static const double _aspectWeight = 1.0;
  static const double _shortestSideWeight = 0.5;

  /// 手机竖屏设计稿（如 iPhone X / 13）。
  static const Size designPhone = Size(375, 812);

  /// iPad 竖屏设计稿。
  static const Size designPad = Size(768, 1024);

  /// iPad 横屏设计稿。
  static const Size designPadLandscape = Size(1024, 768);

  /// 折叠屏展开态设计稿。
  static const Size designFoldable = Size(673, 841);

  static DeviceFormFactor of(BuildContext context) {
    return fromMediaQuery(MediaQuery.of(context));
  }

  /// 根据手机设计稿尺寸，计算出在其他设备上的缩放比例
  static final _ratio = 1 + (DeviceFormFactorUtil.designPhone.width / DeviceFormFactorUtil.designPhone.height);

  static Size designSizeOf(DeviceFormFactor factor) {
    switch (factor) {
      case DeviceFormFactor.phone: return designPhone;
    // case DeviceFormFactor.pad: return designPad;
    // case DeviceFormFactor.padLandscape: return designPadLandscape;
    // case DeviceFormFactor.foldable: return designFoldable;
    // 根据手机设计稿尺寸，在不同设备上缩放比例（如果不需要，对不同设备进行独立布局，推荐使用这种方式）
      default: return Size(DeviceFormFactorUtil.designPhone.width * _ratio, DeviceFormFactorUtil.designPhone.height);
    }
  }

  static DeviceFormFactor fromMediaQuery(MediaQueryData mq) {
    final size = mq.size;
    if (size.shortestSide < _padShortestSideThreshold) {
      return DeviceFormFactor.phone;
    }

    final isLandscape = size.width > size.height;
    final candidates = <DeviceFormFactor>[
      DeviceFormFactor.phone,
      if (isLandscape)
        DeviceFormFactor.padLandscape
      else ...[
        DeviceFormFactor.pad,
        if (_hasFoldableDisplayFeature(mq)) DeviceFormFactor.foldable,
      ],
    ];

    var best = candidates.first;
    var bestDistance = _distance(size, designSizeOf(best));
    for (final factor in candidates.skip(1)) {
      final d = _distance(size, designSizeOf(factor));
      if (d < bestDistance) {
        bestDistance = d;
        best = factor;
      }
    }
    return best;
  }

  static bool _hasFoldableDisplayFeature(MediaQueryData mq) {
    return mq.displayFeatures.any(
      (f) => f.type == DisplayFeatureType.hinge || f.type == DisplayFeatureType.fold,
    );
  }

  static double _distance(Size actual, Size design) {
    final arA = actual.width / actual.height;
    final arD = design.width / design.height;
    final shortA = min(actual.width, actual.height);
    final shortD = min(design.width, design.height);
    return (log(arA) - log(arD)).abs() * _aspectWeight +
        (log(shortA) - log(shortD)).abs() * _shortestSideWeight;
  }
}
