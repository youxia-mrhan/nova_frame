import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/protocol/route_navigation.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/util/toast_util.dart';
import '../../core/shared/refresh/refresh_list_view.dart';

// --- 路由 ---

abstract final class RefreshLoadDemoRt {
  RefreshLoadDemoRt._();

  static const String path = '/demo/refresh_load';
  static const String description = '下拉刷新 / 上拉加载（入口）';
}

abstract final class RefreshLoadListDemoRt {
  RefreshLoadListDemoRt._();

  static const String path = '/demo/refresh_load/list';
  static const String description = 'RefreshListView · ListView';
}

abstract final class RefreshLoadGridDemoRt {
  RefreshLoadGridDemoRt._();

  static const String path = '/demo/refresh_load/grid';
  static const String description = 'RefreshListView · GridView';
}

abstract final class RefreshLoadCustomScrollDemoRt {
  RefreshLoadCustomScrollDemoRt._();

  static const String path = '/demo/refresh_load/custom_scroll';
  static const String description = 'RefreshListView · CustomScrollView';
}

// --- 模拟分页（List / Grid 共用）---

mixin _RefreshLoadPagingMixin<T extends NovaStatefulPageShell> on NovaStatefulPageShellState<T> {
  static const int pageSize = 15;
  static const int maxPage = 5;

  final List<String> items = <String>[];
  int page = 0;
  bool _refreshing = false;
  bool _initialLoading = true;

  Future<void> loadPage({required bool reset, bool showToast = true}) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final nextPage = reset ? 1 : page + 1;
    if (nextPage > maxPage) {
      if (!reset && showToast) {
        ToastUtil.show('没有更多了', gravity: ToastGravity.BOTTOM);
      }
      return;
    }

    final start = (nextPage - 1) * pageSize + 1;
    final batch = List<String>.generate(pageSize, (i) => '条目 ${start + i}');

    setState(() {
      _initialLoading = false;
      page = nextPage;
      if (reset) {
        items
          ..clear()
          ..addAll(batch);
      } else {
        items.addAll(batch);
      }
    });

    if (showToast && mounted) {
      ToastUtil.show(reset ? '已刷新（第 $page 页）' : '已加载第 $page 页', gravity: ToastGravity.BOTTOM);
    }
  }

  Future<void> onRefreshPaging() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      await loadPage(reset: true);
    } finally {
      _refreshing = false;
    }
  }

  Future<bool> onLoadMorePaging() async {
    if (page >= maxPage) return false;
    await loadPage(reset: false);
    return page < maxPage;
  }

  void initPagingData() {
    loadPage(reset: true, showToast: false);
  }

  Widget buildPagingScroll(
    BuildContext context, {
    required ScrollPhysics physics,
    required Widget Function(BuildContext context, ScrollPhysics physics) dataScroll,
  }) {
    if (_initialLoading) {
      return refreshLoadingPlaceholder(physics: physics);
    }
    if (items.isEmpty) {
      return refreshEmptyPlaceholder(physics: physics);
    }
    return dataScroll(context, physics);
  }

  Widget pagingHintBanner(ThemeData theme, {required String scrollType}) {
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.dp, vertical: 10.dp),
        child: Text(
          '$scrollType · 每页 $pageSize 条，共 $maxPage 页。下拉重置；上拉追加。',
          style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
        ),
      ),
    );
  }
}

// --- 入口 ---

@NovaRoute(path: RefreshLoadDemoRt.path, description: RefreshLoadDemoRt.description)
@RoutePage()
class RefreshLoadDemoPage extends NovaPageShell {
  const RefreshLoadDemoPage({super.key});

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('刷新 / 加载更多')),
      body: ListView(
        padding: EdgeInsets.all(24.dp),
        children: [
          Text(
            '滚动体由外部 [scrollBuilder] 传入；C 仅演示下拉刷新。',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          SizedBox(height: 24.dp),
          FilledButton(
            onPressed: () => context.push(path: RefreshLoadListDemoRt.path),
            child: const Text('A · ListView'),
          ),
          SizedBox(height: 12.dp),
          FilledButton.tonal(
            onPressed: () => context.push(path: RefreshLoadGridDemoRt.path),
            child: const Text('B · GridView'),
          ),
          SizedBox(height: 12.dp),
          FilledButton.tonal(
            onPressed: () => context.push(path: RefreshLoadCustomScrollDemoRt.path),
            child: const Text('C · CustomScrollView（仅下拉刷新）'),
          ),
        ],
      ),
    );
  }
}

// --- A：ListView ---

@NovaRoute(path: RefreshLoadListDemoRt.path, description: RefreshLoadListDemoRt.description)
@RoutePage()
class RefreshLoadListDemoPage extends NovaStatefulPageShell {
  const RefreshLoadListDemoPage({super.key});

  @override
  State<RefreshLoadListDemoPage> createState() => _RefreshLoadListDemoPageState();
}

class _RefreshLoadListDemoPageState extends NovaStatefulPageShellState<RefreshLoadListDemoPage>
    with _RefreshLoadPagingMixin {
  @override
  void initState() {
    super.initState();
    initPagingData();
  }

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('ListView')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pagingHintBanner(theme, scrollType: 'ListView'),
          Expanded(
            child: RefreshListView(
              onRefresh: onRefreshPaging,
              onLoadMore: onLoadMorePaging,
              scrollBuilder: (context, physics) => buildPagingScroll(
                context,
                physics: physics,
                dataScroll: (context, physics) => ListView.builder(
                  physics: physics,
                  padding: EdgeInsets.symmetric(vertical: 8.dp),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(items[index]),
                      subtitle: Text('index=$index · page=$page'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- B：GridView ---

@NovaRoute(path: RefreshLoadGridDemoRt.path, description: RefreshLoadGridDemoRt.description)
@RoutePage()
class RefreshLoadGridDemoPage extends NovaStatefulPageShell {
  const RefreshLoadGridDemoPage({super.key});

  @override
  State<RefreshLoadGridDemoPage> createState() => _RefreshLoadGridDemoPageState();
}

class _RefreshLoadGridDemoPageState extends NovaStatefulPageShellState<RefreshLoadGridDemoPage>
    with _RefreshLoadPagingMixin {
  @override
  void initState() {
    super.initState();
    initPagingData();
  }

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('GridView')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pagingHintBanner(theme, scrollType: 'GridView'),
          Expanded(
            child: RefreshListView(
              onRefresh: onRefreshPaging,
              onLoadMore: onLoadMorePaging,
              scrollBuilder: (context, physics) => buildPagingScroll(
                context,
                physics: physics,
                dataScroll: (context, physics) => GridView.builder(
                  physics: physics,
                  padding: EdgeInsets.all(12.dp),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.dp,
                    crossAxisSpacing: 8.dp,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${index + 1}', style: theme.textTheme.titleLarge),
                            SizedBox(height: 4.dp),
                            Text(items[index], textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- C：CustomScrollView（仅下拉刷新）---

@NovaRoute(path: RefreshLoadCustomScrollDemoRt.path, description: RefreshLoadCustomScrollDemoRt.description)
@RoutePage()
class RefreshLoadCustomScrollDemoPage extends NovaStatefulPageShell {
  const RefreshLoadCustomScrollDemoPage({super.key});

  @override
  State<RefreshLoadCustomScrollDemoPage> createState() => _RefreshLoadCustomScrollDemoPageState();
}

class _RefreshLoadCustomScrollDemoPageState extends NovaStatefulPageShellState<RefreshLoadCustomScrollDemoPage> {
  static const int _itemCount = 24;
  int _refreshCount = 0;

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _refreshCount++);
    ToastUtil.show('已刷新（第 $_refreshCount 次）', gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('CustomScrollView')),
      body: RefreshListView(
        onRefresh: _onRefresh,
        scrollBuilder: (context, physics) {
          return CustomScrollView(
            physics: physics,
            slivers: [
              SliverToBoxAdapter(
                child: Material(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: EdgeInsets.all(16.dp),
                    child: Text(
                      'CustomScrollView + SliverList\n'
                      '仅 [onRefresh]，未设置 [onLoadMore]。\n'
                      '刷新次数：$_refreshCount',
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 8.dp),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text('Sliver 条目 ${index + 1}'),
                      );
                    },
                    childCount: _itemCount,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
