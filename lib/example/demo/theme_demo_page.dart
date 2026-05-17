import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../../app/theme/app_theme_type.dart';
import '../../../app/theme/theme_scope.dart';
import '../../core/shared/box/adapt.dart';

abstract final class ThemeDemoRt {
  ThemeDemoRt._();
  static const String path = '/demo/theme';
  static const String description = '主题切换 Demo';
}

@NovaRoute(path: ThemeDemoRt.path, description: ThemeDemoRt.description)
@RoutePage()
class ThemeDemoPage extends NovaPageShell {
  const ThemeDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    final controller = ThemeScope.controllerOf(context);
    final colors = ThemeScope.colorsOf(context);

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        title: Text('主题切换 Demo', style: TextStyle(color: colors.textPrimary)),
        backgroundColor: colors.appBarBg,
      ),
      body: _Header(
        title: '当前主题：${controller.type.name}',
        type: controller.type,
        onSelect: controller.setTheme,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.type,
    required this.onSelect,
  });

  final String title;
  final AppThemeType type;
  final ValueChanged<AppThemeType> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            SizedBox(height: 12.dp),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: AppThemeType.values.map((t) {
                final selected = t == type;
                final label = t.name;
                final button = selected
                    ? FilledButton(
                        onPressed: () => onSelect(t),
                        child: Text(label),
                      )
                    : OutlinedButton(
                        onPressed: () => onSelect(t),
                        child: Text(label),
                      );
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.dp),
                  child: button,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
