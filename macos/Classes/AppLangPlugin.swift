import Cocoa
import FlutterMacOS

public class AppLangPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_lang", binaryMessenger: registrar.messenger)
    let instance = AppLangPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  switch call.method {
    case "getPhoneLanguage":
      result(Locale.current.languageCode)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
