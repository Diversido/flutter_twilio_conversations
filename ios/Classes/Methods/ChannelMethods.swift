import Flutter
import Foundation
import TwilioConversationsClient

// swiftlint:disable type_body_length
public class ChannelMethods {
    public static func join(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.join => onSuccess")
                channel.join { (result: TCHResult) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.join (Channel.join) => onSuccess")
                        flutterResult(nil)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.join (Channel.join) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "Error joining channel (Channel.join) with sid \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                }
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.join => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "Error joining channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func leave(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.leave => onSuccess")
                channel.leave { (result: TCHResult) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.leave (Channel.leave) => onSuccess")
                        flutterResult(nil)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.leave (Channel.leave) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.leave => Error leaving channel (Channel.leave) with sid \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                }
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.leave => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.leave => Error leaving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func typing(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.typing => onSuccess")
                channel.typing()
                flutterResult(nil)
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.typing => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.typing => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func destroy(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.destroy => onSuccess")
                channel.destroy(completion: { (result: TCHResult) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.destroy (Channel.destroy) => onSuccess")
                        flutterResult(nil)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.destroy (Channel.destroy) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.destroy => Error destroying channel \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                })
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.destroy => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.destroy => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func getMessagesCount(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMessagesCount => onSuccess")
                channel.getMessagesCount(completion: { (result: TCHResult, count: UInt) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMessagesCount (Channel.getMessagesCount) => onSuccess: \(count)")
                        flutterResult(count)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMessagesCount (Channel.getMessagesCount) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getMessagesCount => Error retrieving message count for channel \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                })
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMessagesCount => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getMessagesCount => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func getUnreadMessagesCount(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getUnreadMessagesCount => onSuccess")
                channel.getUnreadMessagesCount(completion: { (result: TCHResult, count: NSNumber?) in
                    let count = count
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.getUnreadMessagesCount (Channel.getUnreadMessagesCount) => onSuccess: \(count)")
                        flutterResult(count)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.getUnreadMessagesCount (Channel.getUnreadMessagesCount) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getUnreadMessagesCount => Error retrieving unread message count " +
                            "for channel \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                })
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getUnreadMessagesCount => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getUnreadMessagesCount  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func getMembersCount(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMembersCount => onSuccess")
                channel.getParticipantsCount(completion: { (result: TCHResult, count: UInt) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMembersCount (Channel.getMembersCount) => onSuccess: \(count)")
                        flutterResult(count)
                    } else {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMembersCount (Channel.getMembersCount) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getMembersCount => Error retrieving member count for channel \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                })
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getMembersCount => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getMembersCount  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func setAttributes(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let attributesDict = arguments["attributes"] as? [String: Any?] else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        let attributes = TCHJsonAttributes.init(dictionary: attributesDict as [AnyHashable: Any])

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setAttributes => onSuccess")
                channel.setAttributes(attributes, completion: { (result: TCHResult) in
                    if result.isSuccessful {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.setAttributes (Channel.setAttributes) => onSuccess")
                        flutterResult(Mapper.attributesToDict(attributes))
                    } else {
                        SwiftTwilioConversationsPlugin.debug("ChannelMethods.setAttributes (Channel.setAttributes) => onError: \(String(describing: result.error))")
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setAttributes => Error setting attributes for channel \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                })
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setAttributes => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setAttributes  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func getFriendlyName(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getFriendlyName => onSuccess")
                flutterResult(channel.friendlyName)
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getFriendlyName => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getFriendlyName  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func setFriendlyName(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let friendlyName = arguments["friendlyName"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setFriendlyName => onSuccess")
                channel.setFriendlyName(friendlyName) { (result: TCHResult) in
                    if result.isSuccessful {
                        flutterResult(channel.friendlyName)
                    } else {
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setFriendlyName  => Error setting friendlyName for channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                }
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setFriendlyName => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setFriendlyName  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func getNotificationLevel(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getNotificationLevel => onSuccess")
                flutterResult(channel.notificationLevel)
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getNotificationLevel => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getNotificationLevel  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func setNotificationLevel(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let notificationLevelString = arguments["notificationLevel"] as? String,
            let notificationLevel = Mapper.stringToChannelNotificationLevel(notificationLevelString) else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setNotificationLevel => onSuccess")

                channel.setNotificationLevel(notificationLevel, completion: { (result: TCHResult) in
                    if result.isSuccessful {
                        flutterResult(Mapper.channelNotificationLevelToString(channel.notificationLevel))
                    } else {
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setNotificationLevel  => Error setting notificationLevel for channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                })
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setNotificationLevel => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setNotificationLevel  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func getUniqueName(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getUniqueName => onSuccess")
                flutterResult(channel.uniqueName)
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.getUniqueName => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.getUniqueName  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }

    public static func setUniqueName(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let channelSid = arguments["channelSid"] as? String,
            let uniqueName = arguments["uniqueName"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setUniqueName => onSuccess")

                channel.setUniqueName(uniqueName, completion: { (result: TCHResult) in
                    if result.isSuccessful {
                        flutterResult(channel.uniqueName)
                    } else {
                        flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setUniqueName  => Error setting uniqueName for channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
                    }
                })
            } else {
                SwiftTwilioConversationsPlugin.debug("ChannelMethods.setUniqueName => onError: \(String(describing: result.error))")
                flutterResult(FlutterError(code: "ERROR", message: "ChannelMethods.setUniqueName  => Error retrieving channel with sid \(channelSid): \(String(describing: result.error))", details: nil))
            }
        })
    }
}
