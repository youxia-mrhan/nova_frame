import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/services/network/config/auth_config.dart';
import '../../../core/shared/layouts/nova_page_shell.dart';
import '../../../core/navigation/annotation/nova_route.dart';
import '../../../core/navigation/nova_router.dart';
import '../../../core/shared/box/adapt.dart';

enum LoginDemoStyle { fullScreen, bottomOverlay }

abstract final class LoginDemoRt {
  LoginDemoRt._();

  static const String path = '/demo/login_demo';
  static const String description = 'Router Demo · 登录内容（独立）';
}

/// 登录页面
/// 全屏 / 半屏幕
@NovaRoute(path: LoginDemoRt.path, description: LoginDemoRt.description)
@RoutePage()
class LoginDemoPage extends NovaPageShell {
  LoginDemoPage({super.key, @QueryParam('style') String? styleKey}) : _style = _parseStyle(styleKey);

  final LoginDemoStyle _style;

  static LoginDemoStyle _parseStyle(String? key) {
    switch (key) {
      case 'bottomOverlay':
        return LoginDemoStyle.bottomOverlay;
      case 'fullScreen':
      default:
        return LoginDemoStyle.fullScreen;
    }
  }

  @override
  Widget buildPhone(BuildContext context) {
    return PopScope(
      canPop: false,
      child: switch (_style) {
        LoginDemoStyle.fullScreen => _FullScreenLogin(body: _LoginBody(onDone: _loginDemoDone)),
        LoginDemoStyle.bottomOverlay => _BottomOverlayLogin(body: _LoginBody(onDone: _loginDemoDone)),
      },
    );
  }

  /// 模拟登录成功：写入 token 后 pop；[AuthInterceptor] 在 `await push` 返回后会 [notifyLoginSuccess] 重放队列。
  static Future<void> _loginDemoDone() async {
    await ApiTokenVault.writeAccess('demo-token');
    novaRouter.pop();
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody({required this.onDone});

  final Future<void> Function() onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('token 过期，请重新登录', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12.dp),
          Text('此 Demo 禁用：系统 back / 点击遮罩关闭', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          FilledButton(
            onPressed: () async {
              await onDone();
            },
            child: const Text('关闭（模拟登录完成）'),
          ),
        ],
      ),
    );
  }
}

class _FullScreenLogin extends StatelessWidget {
  const _FullScreenLogin({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('登录（全屏，无遮罩）'),
      ),
      body: body,
    );
  }
}

class _BottomOverlayLogin extends StatelessWidget {
  const _BottomOverlayLogin({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.sizeOf(context).height * 0.55).clamp(280.0, 560.0);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.rd), topRight: Radius.circular(16.rd)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('登录（半屏，有遮罩）'),
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
