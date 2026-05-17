import 'package:flutter/services.dart';

import '../channel/channel_names.dart';
import '../channel/channel_result.dart';
import 'native_platform_api.dart';

/// 具体的实现类，使用 MethodChannel 与原生平台进行通信
class MethodChannelNativePlatformApi implements NativePlatformApi {
  MethodChannelNativePlatformApi({MethodChannel? channel}) : _channel = channel ?? const MethodChannel(ChannelNames.platform);

  final MethodChannel _channel;

  @override
  Future<ChannelResult<String>> getPlatformVersion() async {
    try {
      final r = await _channel.invokeMethod<String>('getPlatformVersion');
      return ChannelResult.success(r ?? 'unknown');
    } catch (e, st) {
      return ChannelResult.failure(e, st);
    }
  }
}
