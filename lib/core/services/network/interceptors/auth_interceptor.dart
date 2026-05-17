import 'package:dio/dio.dart' as dio_pkg;

import '../../../../app/res/app_strings.dart';
import '../../../../example/router_demo/login/login_shell_route_pages.dart';
import '../../../foundation/logger/nova_logger.dart';
import '../../../navigation/nova_navigator_context.dart';
import '../../../navigation/protocol/route_navigation.dart';
import '../config/auth_config.dart';

/// 处理token过期/未登录时的拦截器
final class AuthInterceptor extends dio_pkg.Interceptor {
  AuthInterceptor(this._businessDio);

  final dio_pkg.Dio _businessDio;

  /// 存储触发401请求配置，登录后逐条重试
  final ReAuthQueue _queue = ReAuthQueue();

  /// 执行重新登录流程的方法
  Future<void>? _loginReplayFlow;

  @override
  void onRequest(dio_pkg.RequestOptions options, dio_pkg.RequestInterceptorHandler handler) {
    _attachBearerThenNext(options, handler);
  }

  Future<void> _attachBearerThenNext(dio_pkg.RequestOptions options, dio_pkg.RequestInterceptorHandler handler) async {
    try {
      final token = await ApiTokenVault.readAccess();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e, st) {
      NovaLogger.d('AuthInterceptor.onRequest', error: e, stackTrace: st);
    }
    handler.next(options);
  }

  @override
  void onError(dio_pkg.DioException err, dio_pkg.ErrorInterceptorHandler handler) {
    _onErrorAsync(err, handler);
  }

  Future<void> _onErrorAsync(dio_pkg.DioException err, dio_pkg.ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final ro = err.requestOptions;

    if (ro.extra['skipLoginQueue'] == true) {
      handler.next(err);
      return;
    }

    if (status != 401) {
      handler.next(err);
      return;
    }

    _queue.add(ro, handler);

    // `??=`：处理多个 401 请求
    _loginReplayFlow ??= _openLoginRouteThenReplay();
    try {
      // 共享一次 登录/重新登录流程
      // 多个 await 用同一个 Future 实例，只执行一次，也共享这一次的结果
      await _loginReplayFlow!;
    } catch (e, st) {
      NovaLogger.d('AuthInterceptor._loginReplayFlow', error: e, stackTrace: st);
    }
  }

  /// 执行重新登录流程的方法
  Future<void> _openLoginRouteThenReplay() async {
    try {
      final ctx = NovaNavigatorContext.context;
      if (ctx == null) {
        NovaLogger.d('AuthInterceptor: NovaNavigatorContext.context 为空，无法 push 登录页');
        _rejectAllPending(err: AppStrings.navigatorNotReady);
        return;
      }

      // 唤醒登录页
      await ctx.push(path: LoginFullRt.path, description: LoginFullRt.description);

      // 登录页成功后，重新请求，之前触发401的接口
      await notifyLoginSuccess();

      // 如果服务端设计刷新token机制，是有专门的接口用来刷新 token
      //
      // 伪代码：
      //  1、从本地取出一个refreshToken（这种设计，登录接口都会给两个token：token、refreshToken）
      //  final refreshToken = await ApiTokenVault.readRefreshToken();
      //
      //  2、如果refreshToken存在，调用刷新接口刷新token
      //  if(refreshToken != null) {
      //    final successOrFail = await ApiRefreshToken(refreshToken);
      //    if(successOrFail) {
      //      // token刷新成功，继续之前的请求
      //      await notifyLoginSuccess();
      //    } else {
      //      // token刷新失败，先删除本地的refreshToken，否则还会进入这个流程，继续刷新，死循环；
      //      await ApiTokenVault.deleteRefreshToken();
      //
      //      // 然后唤醒登录页
      //      await ctx.push(path: LoginFullRt.path, description: LoginFullRt.description);
      //      await notifyLoginSuccess();
      //    }
      //  } else {
      //      // 没有refreshToken，直接唤醒登录页
      //      await ctx.push(path: LoginFullRt.path, description: LoginFullRt.description);
      //      await notifyLoginSuccess();
      //  }
    } catch (e, st) {
      NovaLogger.d('AuthInterceptor._openLoginRouteThenReplay', error: e, stackTrace: st);
      _rejectAllPending(err: AppStrings.loginReplayFailed);
    } finally {
      _loginReplayFlow = null;
    }
  }

  /// 登录页成功后调用，逐条重试之前401的接口
  Future<void> notifyLoginSuccess() async {
    await _drainResolving();
  }

  void notifyLoginCancelled() {
    _rejectAllPending(err: AppStrings.loginCancelled);
  }

  Future<void> _drainResolving() async {
    while (_queue.isNotEmpty) {
      final batch = _queue.drain();
      for (final item in batch) {
        try {
          final resp = await _retry(item.request);
          item.handler.resolve(resp);
        } catch (e, st) {
          item.handler.reject(
            e is dio_pkg.DioException
                ? e
                : dio_pkg.DioException(requestOptions: item.request, error: e, stackTrace: st),
          );
        }
      }
    }
  }

  void _rejectAllPending({required String err}) {
    final batch = _queue.drain();
    for (final item in batch) {
      item.handler.reject(
        dio_pkg.DioException(requestOptions: item.request, type: dio_pkg.DioExceptionType.cancel, message: err),
      );
    }
  }

  Future<dio_pkg.Response<dynamic>> _retry(dio_pkg.RequestOptions requestOptions) async {
    final token = await ApiTokenVault.readAccess();
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      headers.remove('Authorization');
    }
    final next = requestOptions.copyWith(headers: headers);
    return _businessDio.fetch<dynamic>(next);
  }
}
