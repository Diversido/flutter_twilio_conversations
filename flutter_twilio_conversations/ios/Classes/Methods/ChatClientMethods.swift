import Flutter
import Foundation
import TwilioConversationsClient

public class ChatClientMethods {
    public static func updateToken(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let token = arguments["token"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'token' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.updateToken(token, completion: {(result: TCHResult) -> Void in
            if result.isSuccessful {
                SwiftTwilioConversationsPlugin.debug("ChatClientMethods.updateToken => onSuccess")
                flutterResult(nil)
            } else {
                if let error = result.error as NSError? {
                    SwiftTwilioConversationsPlugin.debug("ChatClientMethods.updateToken => onError: \(error)")
                    flutterResult(FlutterError(code: "\(error.code)", message: "\(error.description)", details: nil))
                }
            }
            } as TCHCompletion)
    }

    public static func shutdown(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.shutdown()
        result(nil)
    }
}
