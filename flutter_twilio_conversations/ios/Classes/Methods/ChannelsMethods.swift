import Flutter
import Foundation
import TwilioConversationsClient

public class ChannelsMethods {
    public static func createChannel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let friendlyName = arguments["friendlyName"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'friendlyName' parameter", details: nil))
        }

//        guard let channelTypeString = arguments["channelType"] as? String else {
//            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelType' parameter", details: nil))
//        }
//
//         guard let channelType = Mapper.stringToChannelType(channelTypeString) else {
//             return result(FlutterError(code: "MISSING_PARAMS", message: "Could no parse 'channelType' parameter", details: nil))
//         }

        let channelOptions: [String: Any] = [
            TCHConversationOptionFriendlyName: friendlyName,
            //TCHConversationOptionType: channelType.rawValue
        ]

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.createConversation(options: channelOptions, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelsMethods.createChannel => onSuccess")
                flutterResult(Mapper.channelToDict(channel))
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelsMethods.createChannel => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "Error creating channel with friendlyName '\(friendlyName)': \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func getChannel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSidOrUniqueName = arguments["channelSidOrUniqueName"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSidOrUniqueName' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSidOrUniqueName, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelsMethods.getChannel => onSuccess")
                flutterResult(Mapper.channelToDict(channel))
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelsMethods.getChannel => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid or uniqueName '\(channelSidOrUniqueName)'", details: nil))
            }
        })
    }

    public static func getUserChannelsList(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let chatClient = SwiftTwilioConversationsPlugin.chatListener?.chatClient else {
            SwiftTwilioConversationsPlugin.debug("ChannelsMethods.getUserChannelsList => onError: chatClient is not ready")
            return result(FlutterError(code: "ERROR", message: "Error retrieving user channels list", details: nil))
        }
        
        SwiftTwilioConversationsPlugin.debug("ChannelsMethods.getUserChannelsList => onSuccess")
        result(Mapper.channelsToDict(chatClient))
    }

    public static func getMembersByIdentity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        var membersList: [[String: Any?]] = []
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.myConversations()?.forEach({ (channel: TCHConversation) in
            if let member = channel.participant(withIdentity: identity) {
                membersList.append(Mapper.memberToDict(member, channelSid: channel.sid))
            }
        })
        result(membersList)
    }
}
