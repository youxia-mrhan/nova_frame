
import '../channel/channel_result.dart';

/// Flutter 端的抽象层，定义了与原生平台交互的方法接口
abstract class NativePlatformApi {
  /// 获取系统版本信息
  Future<ChannelResult<String>> getPlatformVersion();
}

