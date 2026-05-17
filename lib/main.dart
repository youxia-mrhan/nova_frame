import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/navigation/nova_route_observer.dart';
import 'core/services/network/config/api_config.dart';
import 'core/navigation/nova_router.dart';
import 'core/telemetry/lifecycle/app_lifecycle_tracker.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_controller.dart';
import 'app/theme/theme_scope.dart';
import 'core/shared/box/adapt.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.loadPersistedOrDefault();
  if (kDebugMode) {
    // 配置代理抓包
    // ApiClient.setProxy('192.168.40.187:9000');
  }
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  static final ThemeController _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return ScreenAdaptInit(
      child: AppLifecycleTracker(
        child: ThemeScope(
          controller: _themeController,
          child: AnimatedBuilder(
            animation: _themeController,
            builder: (context, _) {
              final colors = ThemeScope.colorsByType(_themeController.type);
              return _ThemedMaterialApp(theme: AppTheme.fromColors(colors));
            },
          ),
        ),
      ),
    );
  }
}

class _ThemedMaterialApp extends StatelessWidget {
  const _ThemedMaterialApp({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: novaRouter.config(
        deepLinkBuilder: novaDeepLinkBuilder,
        navigatorObservers: () => <NavigatorObserver>[NovaRouteObserver.instance],
      ),
    );
  }
}
