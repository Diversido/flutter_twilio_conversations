import Flutter
import Foundation
import TwilioConversationsClient
import UIKit

public class MessagesMethods {
    // swiftlint:disable:next cyclomatic_complexity
    public static func sendMessage(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let options = arguments["options"] as? [String: Any],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }
        
        SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage => started")

        let mediaProgressListenerId = options["mediaProgressListenerId"]

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage => got conversation")
                let messagePreparator = channel.prepareMessage()
                
                if (options["body"] != nil) {
                    messagePreparator.setBody(options["body"] as? String)
                }
                
                if (options["input"] != nil && options["mimeType"] as? String != nil) {
                    let input = options["input"] as? String
                    
                    guard (options["mimeType"] as? String) != nil else {
                        return flutterResult(FlutterError(code: "ERROR", message: "Missing 'mimeType' in MessageOptions", details: nil))
                    }
                    
                    let inputStream = InputStream(fileAtPath: input!)
                    
                    if (options["filename"] != nil) {                        
                        channel.prepareMessage().addMedia(inputStream: inputStream!, contentType: options["mimeType"] as! String, filename: "image.jpeg", listener: .init(
                            onStarted: {
                                SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage (Message.addMedia) => onStarted")
                                if let id = mediaProgressListenerId, let sink = SwiftTwilioConversationsPlugin.mediaProgressSink {
                                    sink(["mediaProgressListenerId": id, "name": "started"])
                                }
                            },
                            onProgress: {(bytes: UInt) in
                                if let id = mediaProgressListenerId, let sink = SwiftTwilioConversationsPlugin.mediaProgressSink {
                                    sink(["mediaProgressListenerId": id, "name": "progress", "data": bytes])
                                }
                            },
                            onCompleted: {(mediaSid: String) in
                                SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage (Message.addMedia) => onCompleted")
                                if let id = mediaProgressListenerId, let sink = SwiftTwilioConversationsPlugin.mediaProgressSink {
                                    sink(["mediaProgressListenerId": id, "name": "completed", "data": mediaSid])
                                }
                            },
                            onFailed: {(error : Error) in
                                SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage (Message.addMedia) => onFailed")
                                if let id = mediaProgressListenerId, let sink = SwiftTwilioConversationsPlugin.mediaProgressSink {
                                sink(["mediaProgressListenerId": id, "name": "failed"])
                                }
                            }
                            )
                        ).buildAndSend(completion: {
                            (result: TCHResult, message: TCHMessage?) in
                            if result.isSuccessful, let message = message {
                                SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage (Message.sendMessage) => onSuccess")
                                flutterResult(Mapper.messageToDict(message, channelSid: channelSid))
                            } else {
                                SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage (Message.sendMessage) => onError: \(String(describing: result.error))")
                                flutterResult(FlutterError(code: "ERROR", message: "Error sending message with options `\(String(describing: messagePreparator))`", details: nil))
                            }
                        })
                    }
                } else {
                    messagePreparator.buildAndSend(completion: {
                                    (result: TCHResult, message: TCHMessage?) in
                                    if result.isSuccessful, let message = message {
                                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage (Message.sendMessage) => onSuccess")
                                        flutterResult(Mapper.messageToDict(message, channelSid: channelSid))
                                    } else {
                                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.sendMessage (Message.sendMessage) => onError: \(String(describing: result.error))")
                                        flutterResult(FlutterError(code: "ERROR", message: "Error sending message with options `\(String(describing: messagePreparator))`", details: nil))
                                    }
                                })
                }
            }
        })
    }

    public static func removeMessage(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let messageIndex = arguments["messageIndex"] as? NSNumber else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.message(withIndex: messageIndex, completion: { (result: TCHResult, message: TCHMessage?) in
                    if result.isSuccessful, let message = message {
                        channel.remove(message, completion: { (result: TCHResult) in
                            if result.isSuccessful {
                                SwiftTwilioConversationsPlugin.debug("MessagesMethods.removeMessage (Messages.removeMessage) => onSuccess")
                                flutterResult(nil)
                            } else {
                                SwiftTwilioConversationsPlugin.debug("MessagesMethods.removeMessage (Messages.removeMessage) => onError: \(String(describing: result.error))")
                                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving message (index: \(channelSid)) from channel (sid: \(channelSid))", details: nil))
                            }
                        })
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.removeMessage (Messages.messageWithIndex) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error retrieving message (index: \(channelSid)) from channel (sid: \(channelSid))", details: nil))
                    }
                })
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func getMessagesBefore(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let index = arguments["index"] as? UInt,
            let count = arguments["count"] as? UInt else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.getMessagesBefore(index, withCount: count, completion: { (result: TCHResult, messages: [TCHMessage]?) in
                    if result.isSuccessful, let messages = messages {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.getMessagesBefore (Messages.getBefore) => onSuccess")
                        let messagesMap = messages.map { (message: TCHMessage) -> [String: Any?] in
                            return Mapper.messageToDict(message, channelSid: channelSid)
                        }
                        flutterResult(messagesMap)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.getMessagesBefore (Messages.getBefore) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error retrieving \(count) messages before message (index: \(index)) from channel (sid: \(channelSid))", details: nil))
                    }
                })
            }
        })
    }

    public static func getMessagesAfter(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let index = arguments["index"] as? UInt,
            let count = arguments["count"] as? UInt else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.getMessagesAfter(index, withCount: count, completion: { (result: TCHResult, messages: [TCHMessage]?) in
                    if result.isSuccessful, let messages = messages {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.getLastMessages (Messages.getLast) => onSuccess: \(String(describing: messages.last))")
                        let messagesMap = messages.map { (message: TCHMessage) -> [String: Any?] in
                            return Mapper.messageToDict(message, channelSid: channelSid)
                        }
                        flutterResult(messagesMap)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.getMessagesAfter (Messages.getAfter) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error retrieving \(count) messages after message (index: \(index)) from channel (sid: \(channelSid))", details: nil))
                    }
                })
            }
        })
    }

    public static func getLastMessages(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let count = arguments["count"] as? UInt,
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.getLastMessages(withCount: count, completion: { (result: TCHResult, messages: [TCHMessage]?) in
                    if result.isSuccessful, let messages = messages {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.getLastMessages (Messages.getLast) => onSuccess")
                        let messagesMap = messages.map({ (message: TCHMessage) -> [String: Any?] in
                            return Mapper.messageToDict(message, channelSid: channelSid)
                        })
                        flutterResult(messagesMap)
                    }
                })
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func getMessageByIndex(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let messageIndex = arguments["messageIndex"] as? NSNumber else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.message(withIndex: messageIndex, completion: { (result: TCHResult, message: TCHMessage?) in
                    if result.isSuccessful, let message = message {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.getMessageByIndex (Messages.messageWithIndex) => onSuccess")
                        flutterResult(Mapper.messageToDict(message, channelSid: channelSid))
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.removeMessage (Messages.messageWithIndex) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error retrieving message (index: \(channelSid)) from channel (sid: \(channelSid))", details: nil))
                    }
                })
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func setLastReadMessageIndexWithResult(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let lastReadMessageIndex = arguments["lastReadMessageIndex"] as? NSNumber else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.setLastReadMessageIndex(lastReadMessageIndex, completion: { (result: TCHResult, count: UInt) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.setLastReadMessageIndexWithResult (Messages.setLastReadMessageIndex) => onSuccess")
                        flutterResult(count)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.setLastReadMessageIndexWithResult (Messages.setLastReadMessageIndex) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error setting last read message index (index: \(lastReadMessageIndex)) for channel (sid: \(channelSid))", details: nil))
                    }
                })
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func advanceLastReadMessageIndexWithResult(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let lastReadMessageIndex = arguments["lastReadMessageIndex"] as? NSNumber else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.advanceLastReadMessageIndex(lastReadMessageIndex, completion: { (result: TCHResult, count: UInt) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.advanceLastReadMessageIndexWithResult (Messages.advanceLastReadMessageIndex) => onSuccess")
                        flutterResult(count)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.advanceLastReadMessageIndexWithResult (Messages.advanceLastReadMessageIndex) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error advancing last read message index (index: \(lastReadMessageIndex)) for channel with sid '\(channelSid)'", details: nil))
                    }
                })
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func setAllMessagesReadWithResult(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.setAllMessagesReadWithCompletion({ (result: TCHResult, count: UInt) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.setAllMessagesReadWithResult (Messages.setAllMessagesRead) => onSuccess")
                        flutterResult(count)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.setAllMessagesReadWithResult (Messages.setAllMessagesRead) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error setting all messages read for channel (sid: \(channelSid))", details: nil))
                    }
                })
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }

    public static func setNoMessagesReadWithResult(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.setAllMessagesUnreadWithCompletion({ (result: TCHResult, count: NSNumber?) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.setNoMessagesReadWithResult (Messages.setNoMessagesRead) => onSuccess")
                        flutterResult(count)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("MessagesMethods.setNoMessagesReadWithResult (Messages.setNoMessagesRead) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error setting no messages read for channel (sid: \(channelSid))", details: nil))
                    }
                })
            } else {
                flutterResult(FlutterError(code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
            }
        })
    }
}
