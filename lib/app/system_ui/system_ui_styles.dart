import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 顶部状态栏主题。
enum StatusBarTheme {
  /// 背景透明 + 黑字
  transparentDark,

  /// 背景透明 + 白字
  transparentLight,

  /// 白底 + 黑字
  lightBgDark,

  /// 黑底 + 白字
  darkBgLight,

  /// 自定义（使用参数覆盖）
  custom,
}

/// 底部导航栏主题（Android 系统导航栏）
enum SystemNavigationBarTheme {
  /// 白底 + 黑图标/横条
  lightBgDark,

  /// 黑底 + 白图标/横条
  darkBgLight,

  /// 自定义（使用参数覆盖）
  custom,
}

/// 状态栏 / 导航栏样式工具类。
class SystemUiStyles {
  SystemUiStyles._();

  static SystemUiOverlayStyle resolve({
    required StatusBarTheme statusBarTheme,
    required SystemNavigationBarTheme navigationBarTheme,
    Color? customStatusBarColor,
    Brightness? customStatusBarIconBrightness,
    Brightness? customStatusBarBrightness,
    Color? customNavigationBarColor,
    Brightness? customNavigationBarIconBrightness,
  }) {
    final status = _resolveStatusBar(
      theme: statusBarTheme,
      customColor: customStatusBarColor,
      customIconBrightness: customStatusBarIconBrightness,
      customStatusBarBrightness: customStatusBarBrightness,
    );

    final nav = _resolveNavigationBar(
      theme: navigationBarTheme,
      customColor: customNavigationBarColor,
      customIconBrightness: customNavigationBarIconBrightness,
    );

    return status.copyWith(
      systemNavigationBarColor: nav.systemNavigationBarColor,
      systemNavigationBarIconBrightness: nav.systemNavigationBarIconBrightness,
      systemNavigationBarDividerColor: nav.systemNavigationBarDividerColor,
    );
  }

  static SystemUiOverlayStyle _resolveStatusBar({
    required StatusBarTheme theme,
    Color? customColor,
    Brightness? customIconBrightness,
    Brightness? customStatusBarBrightness,
  }) {
    switch (theme) {
      case StatusBarTheme.transparentDark:
        return const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        );
      case StatusBarTheme.transparentLight:
        return const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        );
      case StatusBarTheme.lightBgDark:
        return const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        );
      case StatusBarTheme.darkBgLight:
        return const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        );
      case StatusBarTheme.custom:
        final icon = customIconBrightness ?? Brightness.dark;
        return SystemUiOverlayStyle(
          statusBarColor: customColor ?? Colors.transparent,
          statusBarIconBrightness: icon,
          // iOS 上：statusBarBrightness = 反向的文本颜色语义
          statusBarBrightness: customStatusBarBrightness ?? (icon == Brightness.dark ? Brightness.light : Brightness.dark),
        );
    }
  }

  static SystemUiOverlayStyle _resolveNavigationBar({
    required SystemNavigationBarTheme theme,
    Color? customColor,
    Brightness? customIconBrightness,
  }) {
    switch (theme) {
      case SystemNavigationBarTheme.lightBgDark:
        return const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        );
      case SystemNavigationBarTheme.darkBgLight:
        return const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        );
      case SystemNavigationBarTheme.custom:
        final icon = customIconBrightness ?? Brightness.dark;
        return SystemUiOverlayStyle(
          systemNavigationBarColor: customColor ?? Colors.white,
          systemNavigationBarIconBrightness: icon,
        );
    }
  }
}

