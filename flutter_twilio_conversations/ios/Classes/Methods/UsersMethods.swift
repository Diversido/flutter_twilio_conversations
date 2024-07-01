import Flutter
import Foundation
import TwilioConversationsClient

public class UsersMethods {
    public static func getChannelUserDescriptors(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channelRes = channel as TCHConversation? {
                // FIXME not sure to get users per conversation
                SwiftTwilioConversationsPlugin.debug("UsersMethods.getChannelUserDescriptors => onError: NOT_IMPLEMENTED")
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving user descriptors for channel: NOT_IMPLEMENTED", details: nil))
            } else {
                SwiftTwilioConversationsPlugin.debug("UsersMethods.getChannelUserDescriptors => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel: \(channelSid)", details: nil))
            }
        })
    }

    public static func getUserDescriptor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.subscribedUser(withIdentity: identity, completion: { (result: TCHResult, user: TCHUser?) in
            if result.isSuccessful {
                if let userDesc = user as TCHUser? {
                    SwiftTwilioConversationsPlugin.debug("UsersMethods.getUserDescriptor => onSuccess")
                    flutterResult(Mapper.userDescriptorToDict(userDesc))
                } else {
                    flutterResult(FlutterError(code: "ERROR", message: "Could not resolve userDescriptor for identity: \(identity)", details: nil))
                }
            } else {
                SwiftTwilioConversationsPlugin.debug("UsersMethods.getUserDescriptor => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving userDescriptor for identity: \(identity)", details: nil))
            }
        })
    }

    public static func getAndSubscribeUser(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.subscribedUser(withIdentity: identity, completion: { (result: TCHResult, user: TCHUser?) in
            if result.isSuccessful, let user = user {
                flutterResult(Mapper.userToDict(user))
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error subscribing to user with identity: \(identity)", details: nil))
            }
        })
    }
}
