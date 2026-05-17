import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/navigation/nova_router.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/dialog/bottom_sheet_dialog.dart';
import '../../core/shared/dialog/custom_dialog_util.dart';
import '../../core/shared/dialog/design_aspect_center_dialog.dart';

abstract final class CustomDialogDemoRt {
  CustomDialogDemoRt._();

  static const String path = '/demo/custom_dialog';
  static const String description = '自定义弹窗动画 Demo';
}

@NovaRoute(path: CustomDialogDemoRt.path, description: CustomDialogDemoRt.description)
@RoutePage()
class CustomDialogDemoPage extends NovaPageShell {
  const CustomDialogDemoPage({super.key});

  Future<void> _show(BuildContext context, CustomDialogAnimationType? type, String label) {
    return CustomDialogUtil.showCustomDialog<void>(
      context: context,
      barrierDismissible: true,
      animationType: type,
      builder: (ctx) => Center(
        child: Material(
          borderRadius: BorderRadius.circular(12.rd),
          child: Padding(
            padding: EdgeInsets.all(20.dp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: Theme.of(ctx).textTheme.titleMedium),
                SizedBox(height: 16.dp),
                FilledButton(onPressed: () => novaRouter.pop(), child: const Text('关闭')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildPhone(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('自定义弹窗动画 Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          FilledButton(onPressed: () => _show(context, null, '默认（缩放）'), child: const Text('默认动画（scale）')),
          SizedBox(height: 12.dp),
          FilledButton(
            onPressed: () => _show(context, CustomDialogAnimationType.scale, '缩放 scale'),
            child: const Text('缩放 scale'),
          ),
          SizedBox(height: 12.dp),
          FilledButton(
            onPressed: () => _show(context, CustomDialogAnimationType.slideFromLeft, '自左侧 slide'),
            child: const Text('自左侧 slideFromLeft'),
          ),
          SizedBox(height: 12.dp),
          FilledButton(
            onPressed: () => _show(context, CustomDialogAnimationType.slideFromBottom, '自下侧 slide'),
            child: const Text('自下侧 slideFromBottom'),
          ),
          SizedBox(height: 12.dp),
          FilledButton(
            onPressed: () => _show(context, CustomDialogAnimationType.slideFromTop, '自上侧 slide'),
            child: const Text('自上侧 slideFromTop'),
          ),
          SizedBox(height: 24.dp),
          Text('预设：Bottom sheet / 按 UI 稿宽高比居中', style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 12.dp),
          FilledButton.tonal(
            onPressed: () => BottomSheetDialog.show<void>(
              context: context,
              height: BottomSheetDialogHeight.fixed(220.dp),
              topLeftRadius: 16.rd,
              topRightRadius: 16.rd,
              child: Builder(builder: (ctx) => _demoBottomBody(ctx)),
            ),
            child: const Text('贴底 · 固定高度 220'),
          ),
          SizedBox(height: 12.dp),
          FilledButton.tonal(
            onPressed: () => BottomSheetDialog.show<void>(
              context: context,
              height: const BottomSheetDialogHeight.screenFraction(0.42),
              topLeftRadius: 20.rd,
              topRightRadius: 20.rd,
              child: Builder(builder: (ctx) => _demoBottomBody(ctx)),
            ),
            child: const Text('贴底 · 屏高 42%'),
          ),
          SizedBox(height: 12.dp),
          FilledButton.tonal(
            onPressed: () => DesignAspectCenterDialog.show<void>(
              context: context,
              designWidth: 280.dp,
              designHeight: 200.dp,
              borderRadius: 12.rd,
              animationType: CustomDialogAnimationType.scale,
              child: Builder(
                builder: (ctx) => Padding(
                  padding: EdgeInsets.all(20.dp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('稿 280×200 → 宽=高×(designWidth / designHeight)', style: Theme.of(ctx).textTheme.titleMedium),
                      SizedBox(height: 12.dp),
                      Text('通过自适应的内容高度，结合设计稿宽/高，计算出宽度，避免在 折叠屏、大屏幕，宽度拉升变形。', style: Theme.of(ctx).textTheme.bodyMedium),
                      SizedBox(height: 16.dp),
                      FilledButton(onPressed: () => novaRouter.pop(), child: const Text('关闭')),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('居中 · 宽=高×(280/200)'),
          ),
        ],
      ),
    );
  }

  Widget _demoBottomBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('贴底弹窗', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12.dp),
          const Spacer(),
          FilledButton(onPressed: () => novaRouter.pop(), child: const Text('关闭')),
        ],
      ),
    );
  }
}
