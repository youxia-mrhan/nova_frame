import 'package:flutter/material.dart';

import '../../../navigation/link/nova_app_links.dart';
import '../../util/toast_util.dart';

/// 在根页面包裹使用，初始化一些配置
///
/// 如何想，更早初始化，写在 main 中，非必要不推荐，如果阻塞时间太长，会导致短暂黑屏
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 初始化配置
//   await ApiConfig.loadPersistedOrDefault();
//   await NovaAppLinks.init();
//
//   runApp(const _App());
// }
class InitConfigBox extends StatefulWidget {
  const InitConfigBox({super.key, required this.child});

  final Widget child;

  @override
  State<InitConfigBox> createState() => _InitConfigBoxState();
}

class _InitConfigBoxState extends State<InitConfigBox> {
  @override
  void initState() {
    super.initState();
    NovaAppLinks.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastUtil.init(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
