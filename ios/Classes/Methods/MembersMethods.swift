import Flutter
import Foundation
import TwilioConversationsClient

public class MembersMethods {
    public static func getMembersList(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                flutterResult(Mapper.membersListToDict(channel.participants(), channelSid: channelSid))
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func getMember(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                if let member = channel.participant(withIdentity: identity) {
                    flutterResult(Mapper.memberToDict(member, channelSid: channelSid))
                } else {
                    flutterResult(nil)
                }
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func addByIdentity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("MembersMethods.addByIdentity (Channels.getChannel) => onSuccess")
                channel.addParticipant(byIdentity: identity, attributes: nil, completion: { (result: TCHResult) in
                    if let error = result.error {
                        SwiftTwilioConversationsPlugin.debug("MembersMethods.addByIdentity (Members.addByIdentity) => onError: \(error)")
                        flutterResult(FlutterError(code: "ERROR", message: "Error adding member (sid: \(identity)) to channel (sid: \(channelSid))", details: nil))
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MembersMethods.addByIdentity (Members.addByIdentity) => onCompletion: \(result.isSuccessful)")
                        flutterResult(result.isSuccessful)
                    }
                })
            } else {
                if let error = result.error as NSError? {
                    SwiftTwilioConversationsPlugin.debug("MembersMethods.addByIdentity => onError: \(error)")
                    flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel (sid: \(channelSid))", details: nil))
                }
            }
        })
    }

    // This method is not supported anymore by Twilio Conversations SDK
    // see https://www.twilio.com/docs/conversations/ios/migrate-your-chat-ios-sdk-conversations#remove-or-replace-not-supported-methods
    // and https://www.twilio.com/docs/conversations/ios/migrate-your-chat-ios-sdk-conversations#other-changes
    public static func inviteByIdentity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        return result(FlutterError(code: "NOT_SUPPORTED", message: "This feature is not supported by Twilio Conversations SDK", details: nil))

        // guard let arguments = call.arguments as? [String: Any?] else {
        //     return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        // }

        // guard let channelSid = arguments["channelSid"] as? String else {
        //     return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        // }

        // guard let identity = arguments["identity"] as? String else {
        //     return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        // }

        // let flutterResult = result
        // SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
        //     if result.isSuccessful, let channel = channel {
        //         SwiftTwilioConversationsPlugin.debug("MembersMethods.inviteByIdentity (Channels.getChannel) => onSuccess")
        //         channel.inviteParticipant(byIdentity: identity, completion: { (result: TCHResult) in
        //             if let error = result.error {
        //                 SwiftTwilioConversationsPlugin.debug("MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onError: \(error)")
        //                 flutterResult(FlutterError(code: "ERROR", message: "Error inviting member (sid: \(identity)) to channel (sid: \(channelSid))", details: nil))
        //             } else {
        //                 SwiftTwilioConversationsPlugin.debug("MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onCompletion: \(result.isSuccessful)")
        //                 flutterResult(result.isSuccessful)
        //             }
        //         })
        //     } else {
        //         if let error = result.error as NSError? {
        //             SwiftTwilioConversationsPlugin.debug("MembersMethods.inviteByIdentity => onError: \(error)")
        //             flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel (sid: \(channelSid))", details: nil))
        //         }
        //     }
        // })
    }

    public static func removeByIdentity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("MembersMethods.removeByIdentity (Channels.getChannel) => onSuccess")
                if let member = channel.participant(withIdentity: identity) {
                    channel.removeParticipant(member, completion: { (result: TCHResult) in
                        if let error = result.error {
                            SwiftTwilioConversationsPlugin.debug("MembersMethods.removeByIdentity (Members.inviteByIdentity) => onError: \(error)")
                            flutterResult(FlutterError(code: "ERROR", message: "Error removing member (sid: \(identity)) from channel (sid: \(channelSid))", details: nil))
                        } else {
                            SwiftTwilioConversationsPlugin.debug("MembersMethods.removeByIdentity (Members.inviteByIdentity) => onCompletion: \(result.isSuccessful)")
                            flutterResult(result.isSuccessful)
                        }
                    })
                } else {
                    SwiftTwilioConversationsPlugin.debug("MembersMethods.removeByIdentity (Channel.memberWithIdentity) => onError")
                    flutterResult(FlutterError(code: "ERROR", message: "Error retrieving member (sid: \(identity)) from channel (sid: \(channelSid))", details: nil))
                }
            } else {
                if let error = result.error as NSError? {
                    SwiftTwilioConversationsPlugin.debug("MembersMethods.removeByIdentity => onError: \(error)")
                    flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel (sid: \(channelSid))", details: nil))
                }
            }
        })
    }
}
