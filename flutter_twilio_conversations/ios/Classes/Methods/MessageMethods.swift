import Flutter
import Foundation
import TwilioConversationsClient

public class MessageMethods {
    public static func updateMessageBody(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let messageIndex = arguments["messageIndex"] as? NSNumber else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'messageIndex' parameter", details: nil))
        }

        guard let body = arguments["body"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'body' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("MessageMethods.updateMessageBody (Channels.getChannel) => onSuccess")
                channel.message(withIndex: messageIndex, completion: { (result: TCHResult, message: TCHMessage?) in
                    if result.isSuccessful, let message = message {
                        SwiftTwilioConversationsPlugin.debug("MessageMethods.updateMessageBody (Messages.messageWithIndex) => onSuccess")
                        message.updateBody(body) { (result: TCHResult) in
                            if result.isSuccessful {
                                SwiftTwilioConversationsPlugin.debug("MessageMethods.updateMessageBody (Message.updateMessageBody) => onSuccess")
                                flutterResult(message.body)
                            }
                        }
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessageMethods.updateMessageBody (Messages.messageWithIndex) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error retrieving message (index: \(messageIndex)) from channel (sid: \(channelSid)", details: nil))
                    }
                })
            } else {
                if let error = result.error as NSError? {
                    SwiftTwilioConversationsPlugin.debug("MessageMethods.updateMessageBody => onError: \(error)")
                    flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel (sid: \(channelSid))", details: nil))
                }
            }
        })
    }

    public static func setAttributes(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let messageIndex = arguments["messageIndex"] as? NSNumber else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'messageIndex' parameter", details: nil))
        }

        guard let attributesDict = arguments["attributes"] as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'attributes' parameter", details: nil))
        }

        let attributes = TCHJsonAttributes.init(dictionary: attributesDict as [AnyHashable: Any])

        let flutterResult = result
        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("MessageMethods.setAttributes => onSuccess")
                channel.message(withIndex: messageIndex, completion: { (result: TCHResult, message: TCHMessage?) in
                    if result.isSuccessful, let message = message {
                        SwiftTwilioConversationsPlugin.debug("MessageMethods.setAttributes (Messages.messageWithIndex) => onSuccess")
                        message.setAttributes(attributes) { (result: TCHResult) in
                            if result.isSuccessful {
                                SwiftTwilioConversationsPlugin.debug("MessageMethods.setAttributes (Message.setAttributes) => onSuccess")
                                flutterResult(Mapper.attributesToDict(message.attributes()))
                            } else {
                                SwiftTwilioConversationsPlugin.debug("MessageMethods.setAttributes (Message.setAttributes) => onError: \(String(describing: result.error))")
                            }
                        }
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessageMethods.setAttributes (Messages.messageWithIndex) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error retrieving message (index: \(messageIndex)) from channel (sid: \(channelSid)", details: nil))
                    }
                })
            } else {
                if let error = result.error as NSError? {
                    SwiftTwilioConversationsPlugin.debug("MessageMethods.setAttributes => onError: \(error)")
                    flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid or uniqueName '\(channelSid)'", details: nil))
                }
            }
        })
    }

    public static func getMedia(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let messageIndex = arguments["messageIndex"] as? NSNumber else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

            SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
                if result.isSuccessful, let channel = channel {
                    channel.message(withIndex: messageIndex, completion: { (result: TCHResult, message: TCHMessage?) in
                        if result.isSuccessful, let message = message {
                            message.getTemporaryContentUrlsForAttachedMedia(completion: { (result: TCHResult, urls: Optional<Dictionary<String, URL>>)  in
                                if result.isSuccessful, let urls = urls {
                                    SwiftTwilioConversationsPlugin.debug("getMedia => success: \(String(describing: urls[urls.keys.first!]))")
                                    flutterResult(urls[urls.keys.first!]?.absoluteString)
                                } else {
                                    flutterResult(FlutterError(code: "ERROR", message: "Error getting media content url: \(String(describing: result.error))", details: nil))
                                }
                            })
                        } else {
                            flutterResult(FlutterError(code: "ERROR", message: "Error retrieving message with index '\(messageIndex)'", details: nil))
                        }
                    })
                } else {
                    flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
                }
            })
    }
}
