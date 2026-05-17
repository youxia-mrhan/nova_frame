import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/protocol/route_navigation.dart';
import '../../../app/system_ui/system_ui_styles.dart';
import '../../core/shared/box/adapt.dart';

abstract final class SystemUiStylesDemoRt {
  SystemUiStylesDemoRt._();
  static const String path = '/demo/system_ui_styles';
  static const String description = 'System UI（状态栏/导航栏）Demo';
}

abstract final class SystemUiStylesPreviewDemoRt {
  SystemUiStylesPreviewDemoRt._();
  static const String path = '/demo/system_ui_styles_preview';
  static const String description = 'System UI · 预览页';
}

@NovaRoute(path: SystemUiStylesDemoRt.path, description: SystemUiStylesDemoRt.description)
@RoutePage()
class SystemUiStylesDemoPage extends NovaPageShell {
  const SystemUiStylesDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System UI（状态栏/导航栏）Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Text(
            '此 Demo 仅用于观察：\n'
            '- 顶部状态栏：背景色 + 图标/文字明暗\n'
            '- 底部系统导航栏（Android）：背景色 + 图标/横条明暗\n\n'
            '说明：Flutter 原生 API 只能控制图标/横条“明暗”（Brightness），条实际只有黑/白两种风格，不能直接指定成绿色等任意颜色。',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.dp),
          Text('顶部状态栏', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12.dp),
          _ItemButton(
            title: '背景透明 + 黑字',
            onTap: () => _pushPreview(
              context,
              title: '顶部：透明 + 黑字',
              statusBarTheme: StatusBarTheme.transparentDark,
              navigationBarTheme: SystemNavigationBarTheme.lightBgDark,
            ),
          ),
          _ItemButton(
            title: '背景透明 + 白字',
            onTap: () => _pushPreview(
              context,
              title: '顶部：透明 + 白字',
              statusBarTheme: StatusBarTheme.transparentLight,
              navigationBarTheme: SystemNavigationBarTheme.lightBgDark,
            ),
          ),
          _ItemButton(
            title: '背景白色 + 黑字',
            onTap: () => _pushPreview(
              context,
              title: '顶部：白底 + 黑字',
              statusBarTheme: StatusBarTheme.lightBgDark,
              navigationBarTheme: SystemNavigationBarTheme.lightBgDark,
            ),
          ),
          _ItemButton(
            title: '背景黑色 + 白字',
            onTap: () => _pushPreview(
              context,
              title: '顶部：黑底 + 白字',
              statusBarTheme: StatusBarTheme.darkBgLight,
              navigationBarTheme: SystemNavigationBarTheme.lightBgDark,
            ),
          ),
          _ItemButton(
            title: '自定义：背景红色 + 白字（备注：只支持黑/白两种）',
            onTap: () => _pushPreview(
              context,
              title: '顶部：自定义',
              statusBarTheme: StatusBarTheme.custom,
              navigationBarTheme: SystemNavigationBarTheme.lightBgDark,
              customStatusBarColor: Colors.red,
              customStatusBarIconBrightness: Brightness.light,
            ),
          ),
          SizedBox(height: 20.dp),
          /// 当前导航栏，在Android原生onCreate配置隐藏了，无法展示效果，所以先注释掉。
          /// IOS不支持修改导航栏颜色，始终跟随系统设置。
          // Text('底部状态栏', style: Theme.of(context).textTheme.titleMedium),
          // SizedBox(height: 12.dp),
          // _ItemButton(
          //   title: '背景白色 + 黑条',
          //   onTap: () => _pushPreview(
          //     context,
          //     title: '底部：白底 + 黑条',
          //     statusBarTheme: StatusBarTheme.transparentDark,
          //     navigationBarTheme: SystemNavigationBarTheme.lightBgDark,
          //   ),
          // ),
          // _ItemButton(
          //   title: '背景黑色 + 白条',
          //   onTap: () => _pushPreview(
          //     context,
          //     title: '底部：黑底 + 白条',
          //     statusBarTheme: StatusBarTheme.transparentDark,
          //     navigationBarTheme: SystemNavigationBarTheme.darkBgLight,
          //   ),
          // ),
          // _ItemButton(
          //   title: '自定义：背景红色 + 白条（备注：只支持黑/白两种）',
          //   onTap: () => _pushPreview(
          //     context,
          //     title: '底部：自定义',
          //     statusBarTheme: StatusBarTheme.transparentDark,
          //     navigationBarTheme: SystemNavigationBarTheme.custom,
          //     customNavigationBarColor: Colors.red,
          //     customNavigationBarIconBrightness: Brightness.light,
          //   ),
          // ),
        ],
      ),
    );
  }

  void _pushPreview(
    BuildContext context, {
    required String title,
    required StatusBarTheme statusBarTheme,
    required SystemNavigationBarTheme navigationBarTheme,
    Color? customStatusBarColor,
    Brightness? customStatusBarIconBrightness,
    Color? customNavigationBarColor,
    Brightness? customNavigationBarIconBrightness,
  }) {
    final params = <String, dynamic>{
      'title': title,
      'sb': statusBarTheme.name,
      'nb': navigationBarTheme.name,
    };
    if (customStatusBarColor != null) {
      params['csc'] = customStatusBarColor.toARGB32();
    }
    if (customStatusBarIconBrightness != null) {
      params['csib'] = customStatusBarIconBrightness == Brightness.light ? 'light' : 'dark';
    }
    if (customNavigationBarColor != null) {
      params['cnc'] = customNavigationBarColor.toARGB32();
    }
    if (customNavigationBarIconBrightness != null) {
      params['cnib'] = customNavigationBarIconBrightness == Brightness.light ? 'light' : 'dark';
    }
    context.push(path: SystemUiStylesPreviewDemoRt.path, query: params);
  }
}

@NovaRoute(path: SystemUiStylesPreviewDemoRt.path, description: SystemUiStylesPreviewDemoRt.description)
@RoutePage()
class SystemUiStylesPreviewDemoPage extends NovaPageShell {
  SystemUiStylesPreviewDemoPage({
    super.key,
    @QueryParam('title') this.title,
    @QueryParam('sb') String? sb,
    @QueryParam('nb') String? nb,
    @QueryParam('csc') this.customStatusBarColorValue,
    @QueryParam('csib') String? customStatusBarIconBrightnessKey,
    @QueryParam('cnc') this.customNavigationBarColorValue,
    @QueryParam('cnib') String? customNavigationBarIconBrightnessKey,
  }) : super(
          statusBarTheme: _parseStatusBar(sb),
          navigationBarTheme: _parseNavBar(nb),
          customStatusBarColor: _colorOrNull(customStatusBarColorValue),
          customStatusBarIconBrightness: _brightnessOrNull(customStatusBarIconBrightnessKey),
          customNavigationBarColor: _colorOrNull(customNavigationBarColorValue),
          customNavigationBarIconBrightness: _brightnessOrNull(customNavigationBarIconBrightnessKey),
        );

  final String? title;
  final int? customStatusBarColorValue;
  final int? customNavigationBarColorValue;

  static StatusBarTheme _parseStatusBar(String? s) {
    final key = s ?? 'transparentDark';
    for (final e in StatusBarTheme.values) {
      if (e.name == key) return e;
    }
    return StatusBarTheme.transparentDark;
  }

  static SystemNavigationBarTheme _parseNavBar(String? s) {
    final key = s ?? 'lightBgDark';
    for (final e in SystemNavigationBarTheme.values) {
      if (e.name == key) return e;
    }
    return SystemNavigationBarTheme.lightBgDark;
  }

  static Color? _colorOrNull(int? v) => v == null ? null : Color(v);

  static Brightness? _brightnessOrNull(String? s) {
    if (s == null) return null;
    if (s == 'light') return Brightness.light;
    if (s == 'dark') return Brightness.dark;
    return null;
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Text(title ?? ''),
        ),
      ),
    );
  }
}

class _ItemButton extends StatelessWidget {
  const _ItemButton({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.dp),
      child: FilledButton.tonal(onPressed: onTap, child: Text(title)),
    );
  }
}
