import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/foundation/logger/nova_logger.dart';
import '../../core/navigation/annotation/nova_route.dart';
import '../../core/shared/box/adapt.dart';
import '../../core/shared/layouts/nova_page_shell.dart';
import '../../core/shared/util/permission_util.dart';
import '../../core/shared/util/toast_util.dart';

abstract final class PermissionDemoRt {
  PermissionDemoRt._();

  static const String path = '/demo/permission';
  static const String description = '权限 Demo';
}

class _PermissionDemoItem {
  const _PermissionDemoItem({
    required this.label,
    required this.hint,
    required this.permission,
  });

  final String label;
  final String hint;
  final Permission permission;
}

const _setupHint = '''
IOS需要在 ios/Podfile 开启配置
    ... ... 
    ## dart: PermissionGroup.camera（相机）
    'PERMISSION_CAMERA=1',
    ... ... 
''';

@NovaRoute(
  path: PermissionDemoRt.path,
  description: PermissionDemoRt.description,
)
@RoutePage()
class PermissionDemoPage extends NovaPageShell {
  const PermissionDemoPage({super.key});

  static const _items = <_PermissionDemoItem>[
    _PermissionDemoItem(
      label: '麦克风',
      hint: '录音、语音识别',
      permission: Permission.microphone,
    ),
    _PermissionDemoItem(
      label: '相机',
      hint: '拍照、扫码',
      permission: Permission.camera,
    ),
    _PermissionDemoItem(
      label: '相册',
      hint: '读取照片；Android 13+ 对应 READ_MEDIA_IMAGES',
      permission: Permission.photos,
    ),
    _PermissionDemoItem(
      label: '定位',
      hint: '获取当前位置',
      permission: Permission.locationWhenInUse,
    ),
    _PermissionDemoItem(
      label: '通知',
      hint: '推送、本地通知（Android 13+ 需 POST_NOTIFICATIONS）',
      permission: Permission.notification,
    ),
  ];

  void _toast(BuildContext context, String msg) {
    NovaLogger.d(msg);
    ToastUtil.show(msg, context: context, gravity: ToastGravity.BOTTOM);
  }

  Future<void> _request(BuildContext context, _PermissionDemoItem item) async {
    await PermissionUtil.requestPermission(
      permission: item.permission,
      onResult: (status) {
        if (!context.mounted) return;
        _toast(
          context,
          '${item.label}：${PermissionUtil.getPermissionStatusDescription(status)}',
        );
      },
    );
  }

  Future<void> _checkStatus(BuildContext context, _PermissionDemoItem item) async {
    final status = await PermissionUtil.checkPermissionStatus(item.permission);
    if (!context.mounted) return;
    _toast(
      context,
      '${item.label} 当前：${PermissionUtil.getPermissionStatusDescription(status)}',
    );
  }

  Future<void> _openSettings(BuildContext context) async {
    final ok = await PermissionUtil.openSystemSettings();
    if (!context.mounted) return;
    _toast(context, ok ? '已打开系统设置' : '打开设置失败');
  }

  @override
  Widget buildPhone(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('权限 Demo')),
      body: ListView(
        padding: EdgeInsets.all(16.dp),
        children: [
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: EdgeInsets.all(12.dp),
              child: SelectableText(
                _setupHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.35,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.dp),
          ..._items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.dp),
              child: _PermissionTile(
                item: item,
                onRequest: () => _request(context, item),
                onCheckStatus: () => _checkStatus(context, item),
              ),
            ),
          ),
          SizedBox(height: 8.dp),
          OutlinedButton.icon(
            onPressed: () => _openSettings(context),
            icon: const Icon(Icons.settings_outlined),
            label: const Text('打开系统设置（openAppSettings）'),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.item,
    required this.onRequest,
    required this.onCheckStatus,
  });

  final _PermissionDemoItem item;
  final VoidCallback onRequest;
  final VoidCallback onCheckStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onRequest,
        borderRadius: BorderRadius.circular(12.rd),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 12.dp),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.dp),
                    Text(
                      item.hint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: '查询当前状态',
                onPressed: onCheckStatus,
                icon: Icon(Icons.info_outline, color: theme.colorScheme.secondary),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
