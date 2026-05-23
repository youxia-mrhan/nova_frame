import 'package:flutter/material.dart';

import '../res/app_colors.dart';
import 'app_theme_type.dart';
import 'theme_app_colors.dart';
import 'theme_controller.dart';

/// 设置各种主题色，具体的对应颜色
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController controllerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope not found in widget tree');
    return scope!.notifier!;
  }

  static ThemeAppColors colorsOf(BuildContext context) {
    final controller = controllerOf(context);
    return colorsByType(controller.type);
  }

  static ThemeAppColors colorsByType(AppThemeType type) {
    const light = ThemeAppColors(
      bgPage: AppColors.primary50,
      textPrimary: AppColors.neutral700,
      buttonPrimaryBg: AppColors.primary500,
      appBarBg: AppColors.primary50,
    );

    const dark = ThemeAppColors(
      bgPage: AppColors.neutral900,
      textPrimary: AppColors.white,
      buttonPrimaryBg: AppColors.primary400,
      appBarBg: AppColors.neutral900,
    );

    const ocean = ThemeAppColors(
      bgPage: AppColors.neutral100,
      textPrimary: AppColors.neutral700,
      buttonPrimaryBg: AppColors.stateInfoFg,
      appBarBg: AppColors.neutral100,
    );

    const berry = ThemeAppColors(
      bgPage: AppColors.secondaryBgWarm,
      textPrimary: AppColors.neutral700,
      buttonPrimaryBg: AppColors.stateErrorFg,
      appBarBg: AppColors.secondaryBgWarm,
    );

    switch (type) {
      case AppThemeType.light:
        return light;
      case AppThemeType.dark:
        return dark;
      case AppThemeType.ocean:
        return ocean;
      case AppThemeType.berry:
        return berry;
    }
  }
}

