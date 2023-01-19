import Flutter
import Foundation
import TwilioConversationsClient

public class UserMethods {
    public static func unsubscribe(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.subscribedUser(
            withIdentity: identity, completion: { (result, user) in
                if result.isSuccessful {
                    user?.unsubscribe()
                    flutterResult(nil)
                } else {
                    flutterResult(FlutterError(code: "ERROR",
                        message: "No subscribed user found with the identity '\(identity)'", details: nil))
                }
        })
    }
}
