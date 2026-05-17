import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../../app/res/app_strings.dart';

/// 下拉刷新：完成后返回 [IndicatorResult.success]
/// 异常返回 [IndicatorResult.fail]
typedef OnRefreshCallback = Future<void> Function();

/// 上拉加载：返回 `true` 表示仍有下一页
/// `false` 表示 [IndicatorResult.noMore]；异常为 fail
typedef OnLoadMoreCallback = Future<bool> Function();

/// 由调用方构建可滚动区域
/// 须把 [physics] 传给 [ScrollView]（与 [EasyRefresh.builder] 一致）
typedef RefreshScrollBuilder = Widget Function(BuildContext context, ScrollPhysics physics);

/// 加载占位：在 [RefreshListView] 可视区域内居中展示 loading，且保留 [physics] 以支持下拉刷新。
Widget refreshLoadingPlaceholder({
  required ScrollPhysics physics,
  Widget? child,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        physics: physics,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child ?? const CircularProgressIndicator()),
        ),
      );
    },
  );
}

/// 空列表占位：在 [RefreshListView] 可视区域内垂直水平居中，且保留 [physics] 以支持下拉刷新。
Widget refreshEmptyPlaceholder({
  required ScrollPhysics physics,
  Widget? child,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        physics: physics,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child ?? const Text(AppStrings.emptyData)),
        ),
      );
    },
  );
}

/// [ClassicHeader] 中文文案（后续可接 l10n）。
Header kitClassicHeaderZh() {
  return const ClassicHeader(
    dragText: AppStrings.refreshDrag,
    armedText: AppStrings.refreshArmed,
    readyText: AppStrings.refreshProcessing,
    processingText: AppStrings.refreshProcessing,
    processedText: AppStrings.refreshProcessed,
    failedText: AppStrings.refreshFailed,
    noMoreText: AppStrings.noMore,
    messageText: AppStrings.lastUpdated,
  );
}

/// [ClassicFooter] 中文文案（后续可接 l10n）。
Footer kitClassicFooterZh() {
  return const ClassicFooter(
    dragText: AppStrings.loadDrag,
    armedText: AppStrings.loadArmed,
    readyText: AppStrings.loadProcessing,
    processingText: AppStrings.loadProcessing,
    processedText: AppStrings.loadProcessed,
    failedText: AppStrings.loadFailedFooter,
    noMoreText: AppStrings.noMore,
    messageText: AppStrings.lastUpdated,
  );
}

/// 基于 [easy_refresh] 的下拉刷新 / 上拉加载封装。
///
/// 滚动体由 [scrollBuilder] 提供，可为 [ListView]、[GridView]、[CustomScrollView] 等任意 [ScrollView]。
///
/// - [onRefresh] 为 null 时禁用下拉；
/// - [onLoadMore] 为 null 时禁用上拉；
/// - 未传 [header]/[footer] 时使用 [kitClassicHeaderZh] / [kitClassicFooterZh]。
class RefreshListView extends StatelessWidget {
  const RefreshListView({
    super.key,
    required this.scrollBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.controller,
    this.refreshOnStart = false,
    this.header,
    this.footer,
  });

  final RefreshScrollBuilder scrollBuilder;
  final OnRefreshCallback? onRefresh;
  final OnLoadMoreCallback? onLoadMore;
  final EasyRefreshController? controller;
  final bool refreshOnStart;
  final Header? header;
  final Footer? footer;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: controller,
      refreshOnStart: refreshOnStart,
      header: header ?? kitClassicHeaderZh(),
      footer: footer ?? kitClassicFooterZh(),
      onRefresh: onRefresh == null ? null : () => _runRefresh(onRefresh!),
      onLoad: onLoadMore == null ? null : () => _runLoadMore(onLoadMore!),
      childBuilder: scrollBuilder,
    );
  }

  Future<IndicatorResult> _runRefresh(OnRefreshCallback task) async {
    try {
      await task();
      return IndicatorResult.success;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }

  Future<IndicatorResult> _runLoadMore(OnLoadMoreCallback task) async {
    try {
      final hasMore = await task();
      return hasMore ? IndicatorResult.success : IndicatorResult.noMore;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }
}
