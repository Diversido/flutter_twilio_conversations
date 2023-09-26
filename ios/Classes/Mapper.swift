import Flutter
import TwilioConversationsClient

// swiftlint:disable file_length type_body_length
public class Mapper {
    public static func chatClientToDict(_ chatClient: TwilioConversationsClient?) -> [String: Any] {
        return [
            "channels": channelsToDict(chatClient) as Any,
            "myIdentity": chatClient?.user?.identity as Any,
            "connectionState": clientConnectionStateToString(chatClient?.connectionState),
            "users": usersToDict(chatClient?.users()),
            "isReachabilityEnabled": chatClient?.isReachabilityEnabled() as Any
        ]
    }

    public static func channelsToDict(_ chatClient: TwilioConversationsClient?) -> [String: Any]? {
        if let chatClient = chatClient {
            let subscribedChannelsMap = chatClient.myConversations()?.map({ (channel: TCHConversation) -> [String: Any]? in
                return channelToDict(channel)
            })

            return [
                "subscribedChannels": subscribedChannelsMap as Any
            ]
        }
        return nil
    }

    public static func channelToDict(_ channel: TCHConversation?) -> [String: Any]? {
        if let channel = channel as TCHConversation?, let sid = channel.sid {
            if !SwiftTwilioConversationsPlugin.channelChannels.keys.contains(sid) {
                SwiftTwilioConversationsPlugin.channelChannels[sid] = FlutterEventChannel(name: "flutter_twilio_conversations/\(sid)", binaryMessenger: SwiftTwilioConversationsPlugin.messenger!)
                SwiftTwilioConversationsPlugin.channelChannels[sid]?.setStreamHandler(ChannelStreamHandler(channel))
            }

            return [
                "sid": sid,
                "messages": messagesToDict(channel) as Any,
                "attributes": attributesToDict(channel.attributes()) as Any,
                "status": channelStatusToString(channel.status),
                "synchronizationStatus": channelSynchronizationStatusToString(channel.synchronizationStatus),
                "dateCreated": dateToString(channel.dateCreatedAsDate) as Any,
                "createdBy": channel.createdBy as Any,
                "dateUpdated": dateToString(channel.dateUpdatedAsDate) as Any,
                "lastMessageDate": dateToString(channel.lastMessageDate) as Any,
                "lastMessageIndex": channel.lastMessageIndex as Any
            ]
        } else {
            return nil
        }
    }

    public static func usersToDict(_ users: [TCHUser]?) -> [String: Any?] {
        let subscribedUsersDict = users?.map({ (user: TCHUser) -> [String: Any]? in
            return userToDict(user)
        })
        return [
            "subscribedUsers": subscribedUsersDict,
            "myUser": userToDict(SwiftTwilioConversationsPlugin.chatListener?.chatClient?.user)
        ]
    }

    public static func userToDict(_ user: TCHUser?) -> [String: Any]? {
        if let user = user as TCHUser? {
            return [
                "friendlyName": user.friendlyName as Any,
                "attributes": attributesToDict(user.attributes()) as Any,
                "identity": user.identity as Any,
                "isOnline": user.isOnline(),
                "isNotifiable": user.isNotifiable(),
                "isSubscribed": user.isSubscribed()
            ]
        } else {
            return nil
        }
    }

    public static func userDescriptorToDict(_ userDescriptor: TCHUser) -> [String: Any?] {
        return [
            "friendlyName": userDescriptor.friendlyName,
            "attributes": attributesToDict(userDescriptor.attributes()),
            "identity": userDescriptor.identity,
            "isOnline": userDescriptor.isOnline(),
            "isNotifiable": userDescriptor.isNotifiable()
        ]
    }

    public static func channelDescriptorToDict(_ channelDescriptor: TCHConversation) -> [String: Any?] {
        return [
            "sid": channelDescriptor.sid,
            "friendlyName": channelDescriptor.friendlyName,
            "attributes": attributesToDict(channelDescriptor.attributes()),
            "uniqueName": channelDescriptor.uniqueName,
            "dateUpdated": channelDescriptor.dateUpdated,
            "dateCreated": channelDescriptor.dateCreated,
            "createdBy": channelDescriptor.createdBy,
        ]
    }

    public static func attributesToDict(_ attributes: TCHJsonAttributes?) -> [String: Any?]? {
        if let attr = attributes as TCHJsonAttributes? {
            if attr.isNull {
                return [
                    "type": "NULL",
                    "data": nil
                ]
            } else if attr.isNumber {
                return [
                    "type": "NUMBER",
                    "data": attr.number?.stringValue
                ]
            } else if attr.isArray {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: attr.array as Any) else {
                    return nil
                }
                return [
                    "type": "ARRAY",
                    "data": String(data: jsonData, encoding: String.Encoding.utf8)
                ]
            } else if attr.isString {
                return [
                    "type": "STRING",
                    "data": attr.string
                ]
            } else if attr.isDictionary {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: attr.dictionary as Any) else {
                    return nil
                }
                return [
                    "type": "OBJECT",
                    "data": String(data: jsonData, encoding: String.Encoding.utf8)
                ]
            }
        }
        return nil
    }

    public static func dictToAttributes(_ dict: [String: Any?]) -> TCHJsonAttributes {
        return TCHJsonAttributes.init(dictionary: dict as [AnyHashable: Any])
    }

    public static func messagesToDict(_ channel: TCHConversation?) -> [String: Any?]? {
        if let channel = channel {
            return [
                "lastReadMessageIndex": channel.lastReadMessageIndex
            ]
        }
        return nil
    }

    public static func messageToDict(_ message: TCHMessage, channelSid: String?) -> [String: Any?] {
        var memberDict: [String: Any?]?
        if let member = message.participant {
            memberDict = memberToDict(member, channelSid: channelSid)
        }
        return [
            "sid": message.sid,
            "author": message.author,
            "dateCreated": message.dateCreated,
            "messageBody": message.body,
            "channelSid": channelSid,
            "memberSid": message.participantSid ?? "",
            "member": memberDict,
            "messageIndex": message.index,
            "hasMedia": !message.attachedMedia.isEmpty,
            "media": mediaToDict(message, channelSid),
            "attributes": attributesToDict(message.attributes())
        ]
    }

    public static func mediaToDict(_ message: TCHMessage, _ channelSid: String?) -> [String: Any?]? {
        if message.attachedMedia.isEmpty {
            return nil
        }
        return [
            "sid": message.attachedMedia[0].sid,
            "fileName": message.attachedMedia[0].filename,
            "type": message.attachedMedia[0].contentType,
            "size": message.attachedMedia[0].size,
            "channelSid": channelSid,
            "messageIndex": message.index
        ]
    }

    public static func membersListToDict(_ membersList: [TCHParticipant], channelSid: String) -> [String: [[String: Any?]]] {
        let membersListDict = membersList.map { (member: TCHParticipant) -> [String: Any?] in
            return memberToDict(member, channelSid: channelSid)
        }
        return ["membersList": membersListDict]
    }

    public static func memberToDict(_ member: TCHParticipant, channelSid: String?) -> [String: Any?] {
        return [
            "sid": member.sid,
            "lastReadMessageIndex": member.lastReadMessageIndex,
            "lastConsumptionTimestamp": member.lastReadTimestamp,
            "channelSid": channelSid,
            "identity": member.identity,
            "type": memberTypeToString(member.type),
            "attributes": attributesToDict(member.attributes())
        ]
    }

    public static func errorToDict(_ error: Error?) -> [String: Any?]? {
        if let error = error as NSError? {
            return [
                "code": error.code,
                "message": error.description
            ]
        }

        return nil
    }

    public static func channelStatusToString(_ channelStatus: TCHConversationStatus) -> String {
        let channelStatusString: String

        switch channelStatus {
        case .joined:
            channelStatusString = "JOINED"
        case .notParticipating:
            channelStatusString = "NOT_PARTICIPATING"
        @unknown default:
            channelStatusString = "UNKNOWN"
        }

        return channelStatusString
    }

    public static func clientConnectionStateToString(_ connectionState: TCHClientConnectionState?) -> String {
        var connectionStateString: String = "UNKNOWN"
        if let connectionState = connectionState {
            switch connectionState {
            case .unknown:
                connectionStateString = "UNKNOWN"
            case .disconnected:
                connectionStateString = "DISCONNECTED"
            case .connected:
                connectionStateString = "CONNECTED"
            case .connecting:
                connectionStateString = "CONNECTING"
            case .denied:
                connectionStateString = "DENIED"
            case .error:
                connectionStateString = "ERROR"
            case .fatalError:
                connectionStateString = "FATAL_ERROR"
            default:
                connectionStateString = "UNKNOWN"
            }
        }

        return connectionStateString
    }

    public static func clientSynchronizationStatusToString(_ syncStatus: TCHClientSynchronizationStatus?) -> String {
        var syncStateString: String = "UNKNOWN"
        if let syncStatus = syncStatus {
            switch syncStatus {
            case .started:
                syncStateString = "STARTED"
            case .conversationsListCompleted:
                syncStateString = "CHANNELS_COMPLETED"
            case .completed:
                syncStateString = "COMPLETED"
            case .failed:
                syncStateString = "FAILED"
            default:
                syncStateString = "UNKNOWN"
            }
        }

        return syncStateString
    }

    public static func channelSynchronizationStatusToString(_ syncStatus: TCHConversationSynchronizationStatus) -> String {
        let syncStatusString: String

        switch syncStatus {
        case .none:
            syncStatusString = "NONE"
        case .identifier:
            syncStatusString = "IDENTIFIER"
        case .metadata:
            syncStatusString = "METADATA"
        case .all:
            syncStatusString = "ALL"
        case .failed:
            syncStatusString = "FAILED"
        @unknown default:
            syncStatusString = "UNKNOWN"
        }

        return syncStatusString
    }

    public static func memberTypeToString(_ memberType: TCHParticipantType) -> String {
        let memberTypeString: String

        switch memberType {
        case .unset:
            memberTypeString = "UNSET"
        case .other:
            memberTypeString = "OTHER"
        case .chat:
            memberTypeString = "CHAT"
        case .sms:
            memberTypeString = "SMS"
        case .whatsapp:
            memberTypeString = "CHAT"
        @unknown default:
            memberTypeString = "UNKNOWN"
        }

        return memberTypeString
    }

    public static func messageUpdateToString(_ update: TCHMessageUpdate) -> String {
        let updateString: String

        switch update {
        case .attributes:
            updateString = "ATTRIBUTES"
        case .body:
            updateString = "BODY"
        case .subject:
            updateString = "SUBJECT"
        case .deliveryReceipt:
            updateString = "DELIVERY_RECEIPT"
        @unknown default:
            updateString = "UNKNOWN"
        }

        return updateString
    }

    public static func memberUpdateToString(_ update: TCHParticipantUpdate) -> String {
        let updateString: String

        switch update {
        case .attributes:
            updateString = "ATTRIBUTES"
        case .lastReadMessageIndex:
            updateString = "LAST_CONSUMED_MESSAGE_INDEX"
        case .lastReadTimestamp:
            updateString = "LAST_CONSUMED_MESSAGE_TIMESTAMP"
        @unknown default:
            updateString = "UNKNOWN"
        }

        return updateString
    }

    public static func dateToString(_ date: Date?) -> String? {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: date)
        }
        return nil
    }

    public static func channelNotificationLevelToString(_ notificationLevel: TCHConversationNotificationLevel) -> String {
        switch notificationLevel {
        case .default:
            return "DEFAULT"
        case .muted:
            return "MUTED"
        @unknown default:
            return "UNKNOWN"
        }
    }

    public static func userUpdateToString(_ update: TCHUserUpdate) -> String {
        switch update {
        case .friendlyName:
            return "FRIENDLY_NAME"
        case .attributes:
            return "ATTRIBUTES"
        case .reachabilityOnline:
            return "REACHABILITY_ONLINE"
        case .reachabilityNotifiable:
            return "REACHABILITY_NOTIFIABLE"
        @unknown default:
            return "UNKNOWN"
        }
    }

    public static func channelUpdateToString(_ update: TCHConversationUpdate) -> String {
        switch update {
        case .status:
            return "STATUS"
        case .lastReadMessageIndex:
            return "LAST_CONSUMED_MESSAGE_INDEX"
        case .uniqueName:
            return "UNIQUE_NAME"
        case .friendlyName:
            return "FRIENDLY_NAME"
        case .attributes:
            return "ATTRIBUTES"
        case .lastMessage:
            return "LAST_MESSAGE"
        case .userNotificationLevel:
            return "NOTIFICATION_LEVEL"
        case .state:
            return "STATE"
        @unknown default:
            return "UNKNOWN"
        }
    }

    public static func stringToChannelNotificationLevel(_ notificationLevelString: String?) -> TCHConversationNotificationLevel? {
        if let notificationLevelString = notificationLevelString {
            switch notificationLevelString {
            case "DEFAULT":
                return TCHConversationNotificationLevel.default
            case "MUTED":
                return TCHConversationNotificationLevel.muted
            default:
                return nil
            }
        }
        return nil
    }

    class ChannelStreamHandler: NSObject, FlutterStreamHandler {
        let channel: TCHConversation

        init(_ channel: TCHConversation) {
            self.channel = channel
        }

        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            if let sid = channel.sid {
                SwiftTwilioConversationsPlugin.debug("Mapper.channelToDict => EventChannel for Channel($\(String(describing: sid)) attached")
                SwiftTwilioConversationsPlugin.channelListeners[sid] = ChannelListener(events)
                channel.delegate = SwiftTwilioConversationsPlugin.channelListeners[sid]
            }
            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            if let sid = channel.sid {
                SwiftTwilioConversationsPlugin.debug("Mapper.channelToDict => EventChannel for Channel($\(String(describing: sid)) detached")
                channel.delegate = nil
                SwiftTwilioConversationsPlugin.channelListeners.removeValue(forKey: sid)
                SwiftTwilioConversationsPlugin.channelChannels.removeValue(forKey: sid)
            }
            return nil
        }
    }
}
