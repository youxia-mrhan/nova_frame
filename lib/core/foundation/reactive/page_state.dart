import 'package:flutter/material.dart';
import 'package:nova_frame/core/foundation/reactive/page_load_phase.dart';
import 'package:nova_frame/core/foundation/reactive/page_load_state.dart';
import 'package:nova_frame/core/foundation/reactive/value_state.dart';

import '../../../app/res/app_strings.dart';
import '../../shared/box/adapt.dart';

/// 面向页面接口的 [Vns] 包装
class NovaPageState<T> extends NovaNotifier<NovaPageLoadState<T>> {
  NovaPageState([NovaPageLoadState<T>? initial]) : super(initial ?? NovaPageLoadState.loading());
}

/// 根据请求接口状态，自动切换加载中/成功/失败 UI 的组件
class NovaPageView<T> extends StatefulWidget {
  const NovaPageView({
    super.key,
    required this.ls,
    required this.onRetry,
    required this.successBuilder,
    this.autoDispose = true,
    this.loading,
    this.failure,
  });

  final NovaPageState<T> ls;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) successBuilder;

  /// 为 `true` 时在 dispose 时销毁
  final bool autoDispose;

  /// 自定义加载中 UI；默认居中 [CircularProgressIndicator]。
  final Widget? loading;

  /// 自定义失败 UI；默认文案 + 重试按钮。
  final Widget Function(BuildContext context, String message, VoidCallback onRetry)? failure;

  @override
  State<NovaPageView<T>> createState() => _NovaPageViewState<T>();
}

class _NovaPageViewState<T> extends State<NovaPageView<T>> {
  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.ls.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NovaPageLoadState<T>>(
      valueListenable: widget.ls,
      builder: (context, state, _) {
        switch (state.phase) {
          case NovaPageLoadPhase.loading:
            final Widget body = widget.loading ?? const Center(child: CircularProgressIndicator());
            return _NovaPageViewScaffoldShell(body: body);
          case NovaPageLoadPhase.failure:
            final Widget body = widget.failure != null
                ? widget.failure!(context, state.errorMessage ?? AppStrings.loadFailed, widget.onRetry)
                : _DefaultFailure(message: state.errorMessage ?? AppStrings.loadFailed, onRetry: widget.onRetry);
            return _NovaPageViewScaffoldShell(body: body);
          case NovaPageLoadPhase.success:
            final data = state.data;
            if (data == null) {
              final Widget body = widget.loading ?? const Center(child: CircularProgressIndicator());
              return _NovaPageViewScaffoldShell(body: body);
            }
            return widget.successBuilder(context, data);
          case NovaPageLoadPhase.silentRefresh:
            final data = state.data;
            if (data == null) {
              // 尚未拿到缓存/业务体：不占全屏 loading，仅铺底色（首帧或读盘前）
              return _NovaPageViewScaffoldShell(body: const SizedBox.shrink());
            }
            return widget.successBuilder(context, data);
        }
      },
    );
  }
}

/// 解决无 [Scaffold] 时，跳转页面时，路由区域透出默认黑底背景的组件
/// 统一用主题底色
class _NovaPageViewScaffoldShell extends StatelessWidget {
  const _NovaPageViewScaffoldShell({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor, body: body);
  }
}

class _DefaultFailure extends StatelessWidget {
  const _DefaultFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.dp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            SizedBox(height: 16.dp),
            FilledButton.tonal(onPressed: onRetry, child: const Text(AppStrings.retry)),
          ],
        ),
      ),
    );
  }
}
