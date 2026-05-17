import 'package:flutter/foundation.dart';

import 'app_theme_type.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({AppThemeType initial = AppThemeType.light}) : _type = initial;

  AppThemeType _type;
  AppThemeType get type => _type;

  void setTheme(AppThemeType next) {
    if (_type == next) return;
    _type = next;
    notifyListeners();
  }

  void toggle() {
    final all = AppThemeType.values;
    final idx = all.indexOf(_type);
    final next = all[(idx + 1) % all.length];
    setTheme(next);
  }
}

