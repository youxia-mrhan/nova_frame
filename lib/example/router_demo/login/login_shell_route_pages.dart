import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/shared/layouts/nova_page_shell.dart';
import '../../../core/navigation/annotation/nova_route.dart';
import 'login_demo_page.dart';

abstract final class LoginFullRt {
  LoginFullRt._();
  static const String path = '/login/login_fullscreen';
  static const String description = 'Router Demo · 登录全屏';
}

abstract final class LoginOverlayRt {
  LoginOverlayRt._();
  static const String path = '/login/login_overlay';
  static const String description = 'Router Demo · 登录底部覆盖层';
}

@NovaRoute(path: LoginFullRt.path, description: LoginFullRt.description)
@RoutePage()
class LoginFullScreenShellPage extends NovaPageShell {
  const LoginFullScreenShellPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return LoginDemoPage(styleKey: LoginDemoStyle.fullScreen.name);
  }
}

@NovaRoute(path: LoginOverlayRt.path, description: LoginOverlayRt.description)
@RoutePage()
class LoginOverlayShellPage extends NovaPageShell {
  const LoginOverlayShellPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return LoginDemoPage(styleKey: LoginDemoStyle.bottomOverlay.name);
  }
}
