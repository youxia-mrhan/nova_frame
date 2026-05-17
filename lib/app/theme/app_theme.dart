import 'package:flutter/material.dart';

import '../../core/shared/box/adapt.dart';
import 'theme_app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData fromColors(ThemeAppColors c) {
    final onButtonPrimary = _onColor(c.buttonPrimaryBg);
    final onNavBar = _onColor(c.appBarBg);
    final scheme = ColorScheme.fromSeed(
      seedColor: c.buttonPrimaryBg,
      primary: c.buttonPrimaryBg,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bgPage,
      appBarTheme: AppBarTheme(
        backgroundColor: c.appBarBg,
        foregroundColor: onNavBar,
        elevation: 0,
      ),
      textTheme: const TextTheme().apply(
        bodyColor: c.textPrimary,
        displayColor: c.textPrimary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.buttonPrimaryBg,
          foregroundColor: onButtonPrimary,
          minimumSize: Size.fromHeight(44.dp),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.rd)),
        ),
      ),
    );
  }

  static Color _onColor(Color bg) {
    final brightness = ThemeData.estimateBrightnessForColor(bg);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }
}

