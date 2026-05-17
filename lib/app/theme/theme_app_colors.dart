import 'package:flutter/material.dart';

/// 定义哪些UI颜色，需要主题
class ThemeAppColors {
  const ThemeAppColors({
    // 背景
    required this.bgPage,

    // 文字
    required this.textPrimary,

    // 按钮
    required this.buttonPrimaryBg,

    // appBar
    required this.appBarBg,
  });

  final Color bgPage;
  final Color textPrimary;
  final Color buttonPrimaryBg;
  final Color appBarBg;
}

