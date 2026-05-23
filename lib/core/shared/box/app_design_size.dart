import 'package:flutter/material.dart';
import 'package:nova_frame/app/device/device_form_factor.dart';

/// 各设备形态对应的设计稿尺寸（全局 [ScreenUtilInit] 使用）。
abstract final class AppDesignSize {
  AppDesignSize._();

  /// 手机竖屏设计稿（如 iPhone X / 13）。
  static const Size phone = DeviceFormFactorUtil.designPhone;

  /// iPad 竖屏设计稿。
  static const Size pad = DeviceFormFactorUtil.designPad;

  /// iPad 横屏设计稿。
  static const Size padLandscape = DeviceFormFactorUtil.designPadLandscape;

  /// 折叠屏展开态设计稿（可按 UI 调整）。
  static const Size foldable = DeviceFormFactorUtil.designFoldable;

  static Size of(DeviceFormFactor factor) => DeviceFormFactorUtil.designSizeOf(factor);
}
