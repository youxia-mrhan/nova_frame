import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app/res/app_strings.dart';
import '../../../core/foundation/reactive/page_load_phase.dart';
import '../../../core/foundation/reactive/page_load_state.dart';
import '../../../core/foundation/reactive/provided_consumer.dart';
import '../../../core/foundation/reactive/value_state.dart';
import '../../../core/navigation/annotation/nova_route.dart';
import '../../../core/shared/box/adapt.dart';
import '../../../core/shared/layouts/nova_page_shell.dart';
import '../../../core/shared/util/toast_util.dart';
import '../provider/token_refresh_demo_provider.dart';

abstract final class TokenRefreshDemoRt {
  TokenRefreshDemoRt._();

  static const String path = '/net_demo/token_refresh_demo';
  static const String description = '无感刷新token Demo';
}

/// 401 与全屏登录由 [AuthInterceptor] 统一处理；请求态仅在说明下方一块区域展示（与 [NetDemoProvider] 同源 [NovaPageState] / [NovaPageLoadState]）。
@NovaRoute(path: TokenRefreshDemoRt.path, description: TokenRefreshDemoRt.description)
@RoutePage()
class TokenRefreshDemoPage extends NovaPageShell {
  const TokenRefreshDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('无感刷新token Demo')),
      body: NovaProvidedConsumer<TokenRefreshDemoProvider>(
          create: (_) => TokenRefreshDemoProvider(),
          builder: (_, model, _) {
          return ListView(
            padding: EdgeInsets.all(16.dp),
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(12.dp),
                  child: Text(
                    '当前测试接口，可能需要在代理环境下，才能请求成功；\n\n'
                    '触发 401 时，会唤醒登录弹窗；\n\n'
                    '关闭弹窗，视作登录成功，会更新 token，然后自动重新请求；\n\n'
                    '再次测试需先清除本地 token（当前测试接口在带 token 时，不再 触发401）。',
                    style: TextStyle(height: 1.35),
                  ),
                ),
              ),
              SizedBox(height: 12.dp),
              NovaBuilder<NovaPageLoadState<String>>(
                ls: model.requestPage,
                bx: (context, state, _) {
                  return _requestStatusSlot(context, state, model.fetch401);
                },
              ),
              SizedBox(height: 16.dp),
              FilledButton(onPressed: () {
                // 模拟多个接口同时触发401，验证是否只弹一次登录窗口。
                // 通过观察日志：发起三个接口请求，登录后，用重新请求了这个三个接口
                model.fetch401();
                model.fetch401();
                model.fetch401();
              }, child: const Text('请求')),
              SizedBox(height: 12.dp),
              OutlinedButton(
                onPressed: () async {
                  await model.clearToken();
                  if (!context.mounted) return;
                  ToastUtil.show(
                    '已清除本地 Token',
                    context: context,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
                child: const Text('清除本地 Token'),
              ),
            ],
          );
        }
      ),
    );
  }
}

Widget _requestStatusSlot(BuildContext context, NovaPageLoadState<String> state, VoidCallback onRetry) {
  switch (state.phase) {
    case NovaPageLoadPhase.loading:
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 36.dp),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text(AppStrings.requesting)],
          ),
        ),
      );
    case NovaPageLoadPhase.failure:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.errorMessage ?? AppStrings.requestFailed,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(onPressed: onRetry, child: const Text(AppStrings.retryShort)),
          ),
        ],
      );
    case NovaPageLoadPhase.success:
    case NovaPageLoadPhase.silentRefresh:
      final data = state.data ?? '';
      if (data == '完成') {
        return Text('状态：$data', style: Theme.of(context).textTheme.bodySmall);
      }
      return const SizedBox.shrink();
  }
}
