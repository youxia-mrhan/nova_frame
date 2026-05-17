import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    // 显式创建 FlutterViewController，避免黑屏
    let flutterViewController = FlutterViewController(project: nil, nibName: nil, bundle: nil)
    GeneratedPluginRegistrant.register(with: flutterViewController)

    // 注册自定义通道
    PlatformChannel.register(with: flutterViewController.binaryMessenger)

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = flutterViewController
    self.window = window
    window.makeKeyAndVisible()

    // 让 FlutterSceneDelegate 继续接管后续的 URL/Link 事件分发。
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }
}
