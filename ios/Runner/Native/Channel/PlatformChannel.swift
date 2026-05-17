import Flutter
import UIKit

final class PlatformChannel {
  private static let channelName = "nova/platform"
  private static let methodGetPlatformVersion = "getPlatformVersion"

  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case methodGetPlatformVersion:
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        result("\(systemName ) \(systemVersion)")
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

}
