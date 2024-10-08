import Flutter
import UIKit

public class SwiftBinahFlutterSdkPlugin: NSObject, FlutterPlugin {
    
    static let methodChannelId = "plugins.binah.ai/flutter_plugin"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        let methodChannel = FlutterMethodChannel(name: methodChannelId, binaryMessenger: binaryMessenger)
        let instance = SwiftBinahFlutterSdkPlugin(binaryMessenger: binaryMessenger)
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        registrar.register(BinahPreviewFactory.shared, withId: BinahPreviewFactory.cameraPreviewId)
    }
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        SessionManager.shared.eventChannel = BinahEventChannel(messenger: binaryMessenger)
        BinahPreviewFactory.shared.setDataSource(imageDataSource: SessionManager.shared)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? Dictionary<String, Any>
        do {
            switch (call.method) {
                case NativeBridgeApi.createSession:
                    try SessionManager.shared.createSession(
                        licenseKey: (arguments?["licenseKey"] as? String) ?? "",
                        productId: arguments?["productId"] as? String,
                        measurementMode: arguments?["measurementMode"] as? Int,
                        deviceOrientation: arguments?["deviceOrientation"] as? Int,
                        subjectSex: arguments?["subjectSex"] as? Int,
                        subjectAge: arguments?["subjectAge"] as? Double,
                        subjectWeight: arguments?["subjectWeight"] as? Double,
                        detectionAlwaysOn: arguments?["detectionAlwaysOn"] as? Bool,
                        imageFormatMode: arguments?["imageFormatMode"] as? Int,
                        options: arguments?["options"] as? [String: Any]
                    )
                    result(nil)
                case NativeBridgeApi.startSession:
                    try SessionManager.shared.startSession(duration: arguments?["duration"] as? Int)
                    result(nil)
                case NativeBridgeApi.stopSession:
                    try SessionManager.shared.stopSession()
                    result(nil)
                case NativeBridgeApi.terminateSession:
                    SessionManager.shared.terminateSession()
                    result(nil)
                case NativeBridgeApi.getSessionState:
                    result(SessionManager.shared.getSessionState())
                case NativeBridgeApi.getNativeSdkVersion:
                    result([
                        "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "",
                        "build": Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""
                    ])
                default:
                    return
                    
            }
        }
        catch {
            result(FlutterError(
                code: (error as NSError).code.description,
                message: (error as NSError).domain.description,
                details: nil))
        }
    }
}
