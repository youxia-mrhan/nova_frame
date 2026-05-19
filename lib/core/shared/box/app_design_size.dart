import 'package:flutter/material.dart';
import 'package:nova_frame/app/device/device_form_factor.dart';

/// 各设备形态对应的设计稿尺寸（全局 [ScreenUtilInit] 使用）。
abstract final class AppDesignSize {
  AppDesignSize._();

  /// 手机竖屏设计稿（如 iPhone X / 13）。
  static const Size phone = Size(375, 812);

  /// iPad 竖屏设计稿。
  static const Size pad = Size(768, 1024);

  /// iPad 横屏设计稿。
  static const Size padLandscape = Size(1024, 768);

  /// 折叠屏展开态设计稿（可按 UI 调整）。
  static const Size foldable = Size(673, 841);

  static Size of(DeviceFormFactor factor) => switch (factor) {
        DeviceFormFactor.phone => phone,
        DeviceFormFactor.pad => pad,
        DeviceFormFactor.padLandscape => padLandscape,
        DeviceFormFactor.foldable => foldable,
      };
}
