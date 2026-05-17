import 'package:flutter/material.dart';

import '../../../../app/res/app_strings.dart';
import '../../../core/foundation/reactive/page_load_state.dart';
import '../../../core/foundation/reactive/page_state.dart';
import '../../../core/services/network/config/auth_config.dart';
import '../../../core/services/network/interceptors/error_interceptor.dart';
import '../api/temp_api.dart';

/// 业务层
/// 负责处理数据和业务逻辑，提供给UI层调用
class TokenRefreshDemoProvider extends ChangeNotifier {
  final NovaPageState<String> requestPage = NovaPageState(NovaPageLoadState.success(''));

  Future<void> fetch401() async {
    requestPage.value = NovaPageLoadState.loading();
    try {
      await TempApi().get401Code();
      requestPage.value = NovaPageLoadState.success('完成');
    } catch (e) {
      final msg = e is NetworkException ? (e.errorMsg ?? AppStrings.unknownErr) : '$e';
      requestPage.value = NovaPageLoadState.failure(errorMessage: msg, error: e);
    }
  }

  Future<void> clearToken() async {
    await ApiTokenVault.clear();
    requestPage.value = NovaPageLoadState.success('');
  }

// @override
// void dispose() {
//   super.dispose();
// }
}
