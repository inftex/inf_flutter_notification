import Flutter
import UIKit

public class SwiftInfFlutterNotificationPlugin: NSObject, FlutterPlugin, UIApplicationDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "inf_flutter_notification", binaryMessenger: registrar.messenger())
    let instance = SwiftInfFlutterNotificationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Add the plugin as an application delegate observer
    if let app = UIApplication.shared.delegate as? FlutterAppDelegate {
        app.addApplicationDelegate(instance)
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
  
  // handle lifecycle from plugin
  public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // allow nofitication whilst foreground
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return true
  }
}
