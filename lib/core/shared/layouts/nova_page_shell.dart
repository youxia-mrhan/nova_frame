import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/device/device_form_factor.dart';
import '../../../app/system_ui/system_ui_styles.dart';
import '../../telemetry/session/session_scope.dart';

/// 页面基类：根据设备形态分发到不同 build。
///
/// 如果某种设备暂时没做独立适配：
/// - 默认复用 `buildPhone`
abstract class NovaPageShell extends StatelessWidget {
  const NovaPageShell({
    super.key,
    StatusBarTheme statusBarTheme = StatusBarTheme.transparentDark,
    SystemNavigationBarTheme navigationBarTheme = SystemNavigationBarTheme.lightBgDark,
    SystemUiOverlayStyle? systemUiOverlayStyleOverride,
    Color? customStatusBarColor,
    Brightness? customStatusBarIconBrightness,
    Brightness? customStatusBarBrightness,
    Color? customNavigationBarColor,
    Brightness? customNavigationBarIconBrightness,
    bool fillStatusBarBackground = true,
  })  : _statusBarTheme = statusBarTheme,
        _navigationBarTheme = navigationBarTheme,
        _systemUiOverlayStyleOverride = systemUiOverlayStyleOverride,
        _customStatusBarColor = customStatusBarColor,
        _customStatusBarIconBrightness = customStatusBarIconBrightness,
        _customStatusBarBrightness = customStatusBarBrightness,
        _customNavigationBarColor = customNavigationBarColor,
        _customNavigationBarIconBrightness = customNavigationBarIconBrightness,
        _fillStatusBarBackground = fillStatusBarBackground;

  final StatusBarTheme _statusBarTheme;
  final SystemNavigationBarTheme _navigationBarTheme;
  final SystemUiOverlayStyle? _systemUiOverlayStyleOverride;
  final Color? _customStatusBarColor;
  final Brightness? _customStatusBarIconBrightness;
  final Brightness? _customStatusBarBrightness;
  final Color? _customNavigationBarColor;
  final Brightness? _customNavigationBarIconBrightness;
  final bool _fillStatusBarBackground;

  /// 顶部状态栏主题（默认透明黑字）。
  StatusBarTheme get statusBarTheme => _statusBarTheme;

  /// 底部导航栏主题（默认白底黑字/横条）。
  SystemNavigationBarTheme get navigationBarTheme => _navigationBarTheme;

  /// 自定义 System UI（优先级最高）。
  SystemUiOverlayStyle? get systemUiOverlayStyleOverride => _systemUiOverlayStyleOverride;

  /// 自定义参数：状态栏背景色。
  Color? get customStatusBarColor => _customStatusBarColor;

  /// 自定义参数：状态栏图标/字体颜色。
  Brightness? get customStatusBarIconBrightness => _customStatusBarIconBrightness;

  /// 自定义参数：iOS statusBarBrightness。
  Brightness? get customStatusBarBrightness => _customStatusBarBrightness;

  /// 自定义参数：导航栏背景色。
  Color? get customNavigationBarColor => _customNavigationBarColor;

  /// 自定义参数：导航栏图标/横条颜色。
  Brightness? get customNavigationBarIconBrightness => _customNavigationBarIconBrightness;

  /// 是否绘制“状态栏高度”的顶部背景层，用于 iOS 上同步状态栏背景效果。
  bool get fillStatusBarBackground => _fillStatusBarBackground;

  @override
  Widget build(BuildContext context) {
    // SessionBinding 必须在 buildPhone 之上，否则向上查找取不到 SessionScope。
    return SessionBinding(
      child: Builder(
        builder: (scopedContext) {
          final Widget child = switch (DeviceFormFactorUtil.of(scopedContext)) {
            DeviceFormFactor.phone => buildPhone(scopedContext),
            DeviceFormFactor.pad => buildPad(scopedContext),
            DeviceFormFactor.padLandscape => buildPadLandscape(scopedContext),
            DeviceFormFactor.foldable => buildFoldable(scopedContext),
          };

          final style = systemUiOverlayStyleOverride ??
              SystemUiStyles.resolve(
                statusBarTheme: statusBarTheme,
                navigationBarTheme: navigationBarTheme,
                customStatusBarColor: customStatusBarColor,
                customStatusBarIconBrightness: customStatusBarIconBrightness,
                customStatusBarBrightness: customStatusBarBrightness,
                customNavigationBarColor: customNavigationBarColor,
                customNavigationBarIconBrightness: customNavigationBarIconBrightness,
              );

          // AppBar 会自行设置 SystemUiOverlayStyle（可能覆盖外层 AnnotatedRegion）。
          // 这里通过 AppBarTheme 注入同一份 style，保证顶部状态栏配置生效且与页面保持一致。
          final theme = Theme.of(scopedContext);
          final themedChild = Theme(
            data: theme.copyWith(
              appBarTheme: theme.appBarTheme.copyWith(systemOverlayStyle: style),
            ),
            child: child,
          );

          final composedChild =
              fillStatusBarBackground ? _withStatusBarBackground(scopedContext, themedChild, style) : themedChild;
          return AnnotatedRegion<SystemUiOverlayStyle>(value: style, child: composedChild);
        },
      ),
    );
  }

  Widget _withStatusBarBackground(BuildContext context, Widget child, SystemUiOverlayStyle style) {
    final top = MediaQuery.paddingOf(context).top;
    final color = style.statusBarColor ?? Colors.transparent;
    if (top <= 0 || color == Colors.transparent) return child;
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: top,
          child: IgnorePointer(child: ColoredBox(color: color)),
        ),
      ],
    );
  }

  Widget buildPhone(BuildContext context);

  Widget buildPad(BuildContext context) => buildPhone(context);

  Widget buildPadLandscape(BuildContext context) => buildPad(context);

  Widget buildFoldable(BuildContext context) => buildPhone(context);
}

/// StatefulWidget 页面基类：根据设备形态分发到不同 build。
///
/// 适合需要 `initState / dispose` 的页面。
abstract class NovaStatefulPageShell extends StatefulWidget {
  const NovaStatefulPageShell({
    super.key,
    this.fillStatusBarBackground = true,
  });

  /// 是否绘制“状态栏高度”的顶部背景层，用于 iOS 上同步状态栏背景效果。
  final bool fillStatusBarBackground;
}

abstract class NovaStatefulPageShellState<T extends NovaStatefulPageShell> extends State<T> {
  /// 顶部状态栏主题（默认透明黑字）。
  StatusBarTheme get statusBarTheme => StatusBarTheme.transparentDark;

  /// 底部导航栏主题（默认白底黑字/横条）。
  SystemNavigationBarTheme get navigationBarTheme => SystemNavigationBarTheme.lightBgDark;

  /// 自定义 System UI（优先级最高）。
  SystemUiOverlayStyle? get systemUiOverlayStyleOverride => null;

  /// 自定义参数：状态栏背景色。
  Color? get customStatusBarColor => null;

  /// 自定义参数：状态栏图标/字体颜色。
  Brightness? get customStatusBarIconBrightness => null;

  /// 自定义参数：iOS statusBarBrightness。
  Brightness? get customStatusBarBrightness => null;

  /// 自定义参数：导航栏背景色。
  Color? get customNavigationBarColor => null;

  /// 自定义参数：导航栏图标/横条颜色。
  Brightness? get customNavigationBarIconBrightness => null;

  @override
  Widget build(BuildContext context) {
    return SessionBinding(
      child: Builder(
        builder: (scopedContext) {
          final Widget child = switch (DeviceFormFactorUtil.of(scopedContext)) {
            DeviceFormFactor.phone => buildPhone(scopedContext),
            DeviceFormFactor.pad => buildPad(scopedContext),
            DeviceFormFactor.padLandscape => buildPadLandscape(scopedContext),
            DeviceFormFactor.foldable => buildFoldable(scopedContext),
          };

          final style = systemUiOverlayStyleOverride ??
              SystemUiStyles.resolve(
                statusBarTheme: statusBarTheme,
                navigationBarTheme: navigationBarTheme,
                customStatusBarColor: customStatusBarColor,
                customStatusBarIconBrightness: customStatusBarIconBrightness,
                customStatusBarBrightness: customStatusBarBrightness,
                customNavigationBarColor: customNavigationBarColor,
                customNavigationBarIconBrightness: customNavigationBarIconBrightness,
              );

          final theme = Theme.of(scopedContext);
          final themedChild = Theme(
            data: theme.copyWith(
              appBarTheme: theme.appBarTheme.copyWith(systemOverlayStyle: style),
            ),
            child: child,
          );

          final composedChild =
              widget.fillStatusBarBackground ? _withStatusBarBackground(scopedContext, themedChild, style) : themedChild;
          return AnnotatedRegion<SystemUiOverlayStyle>(value: style, child: composedChild);
        },
      ),
    );
  }

  Widget _withStatusBarBackground(BuildContext context, Widget child, SystemUiOverlayStyle style) {
    final top = MediaQuery.paddingOf(context).top;
    final color = style.statusBarColor ?? Colors.transparent;
    if (top <= 0 || color == Colors.transparent) return child;
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: top,
          child: IgnorePointer(child: ColoredBox(color: color)),
        ),
      ],
    );
  }

  Widget buildPhone(BuildContext context);

  Widget buildPad(BuildContext context) => buildPhone(context);

  Widget buildPadLandscape(BuildContext context) => buildPad(context);

  Widget buildFoldable(BuildContext context) => buildPhone(context);
}

