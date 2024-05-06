import Flutter
import Foundation
import TwilioConversationsClient

public class PluginHandler {
    // swiftlint:disable:next function_body_length
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftTwilioConversationsPlugin.debug("PluginHandler.handle => received \(call.method)")
        switch call.method {
        case "debug":
            debug(call, result: result)
        case "create":
            create(call, result: result)
        case "registerForNotification":
            SwiftTwilioConversationsPlugin.instance?.registerForNotification(call, flutterResult: result)
        case "unregisterForNotification":
            SwiftTwilioConversationsPlugin.instance?.unregisterForNotification(call, flutterResult: result)
        case "handleReceivedNotification":
            SwiftTwilioConversationsPlugin.instance?.handleReceivedNotification(call, flutterResult: result)
        case "ChatClient#updateToken":
            ChatClientMethods.updateToken(call, result: result)
        case "ChatClient#shutdown":
            ChatClientMethods.shutdown(call, result: result)

        case "User#unsubscribe":
            UserMethods.unsubscribe(call, result: result)

        case "Users#getChannelUserDescriptors":
            UsersMethods.getChannelUserDescriptors(call, result: result)
        case "Users#getUserDescriptor":
            UsersMethods.getUserDescriptor(call, result: result)
        case "Users#getAndSubscribeUser":
            UsersMethods.getAndSubscribeUser(call, result: result)

        case "Channel#join":
            ChannelMethods.join(call, result: result)
        case "Channel#leave":
            ChannelMethods.leave(call, result: result)
        case "Channel#typing":
            ChannelMethods.typing(call, result: result)
        case "Channel#destroy":
            ChannelMethods.destroy(call, result: result)
        case "Channel#getMessagesCount":
            ChannelMethods.getMessagesCount(call, result: result)
        case "Channel#getUnreadMessagesCount":
            ChannelMethods.getUnreadMessagesCount(call, result: result)
        case "Channel#getMembersCount":
            ChannelMethods.getMembersCount(call, result: result)
        case "Channel#setAttributes":
            ChannelMethods.setAttributes(call, result: result)
        case "Channel#getFriendlyName":
            ChannelMethods.getFriendlyName(call, result: result)
        case "Channel#setFriendlyName":
            ChannelMethods.setFriendlyName(call, result: result)
        case "Channel#getNotificationLevel":
            ChannelMethods.getNotificationLevel(call, result: result)
        case "Channel#setNotificationLevel":
            ChannelMethods.setNotificationLevel(call, result: result)
        case "Channel#getUniqueName":
            ChannelMethods.getUniqueName(call, result: result)
        case "Channel#setUniqueName":
            ChannelMethods.setUniqueName(call, result: result)

        case "Channels#createChannel":
            ChannelsMethods.createChannel(call, result: result)
        case "Channels#getChannel":
            ChannelsMethods.getChannel(call, result: result)
        case "Channels#getUserChannelsList":
            ChannelsMethods.getUserChannelsList(call, result: result)
        case "Channels#getMembersByIdentity":
            ChannelsMethods.getMembersByIdentity(call, result: result)

        case "Member#getUserDescriptor":
            MemberMethods.getUserDescriptor(call, result: result)
        case "Member#getAndSubscribeUser":
            MemberMethods.getAndSubscribeUser(call, result: result)
        case "Member#setAttributes":
            MemberMethods.setAttributes(call, result: result)

        case "Members#getMembersList":
            MembersMethods.getMembersList(call, result: result)
        case "Members#getMember":
            MembersMethods.getMember(call, result: result)
        case "Members#addByIdentity":
            MembersMethods.addByIdentity(call, result: result)
        case "Members#inviteByIdentity":
            MembersMethods.inviteByIdentity(call, result: result)
        case "Members#removeByIdentity":
            MembersMethods.removeByIdentity(call, result: result)

        case "Message#updateMessageBody":
            MessageMethods.updateMessageBody(call, result: result)
        case "Message#setAttributes":
            MessageMethods.setAttributes(call, result: result)
        case "Message#getMedia":
            MessageMethods.getMedia(call, result: result)

        case "Messages#sendMessage":
            MessagesMethods.sendMessage(call, result: result)
        case "Messages#removeMessage":
            MessagesMethods.removeMessage(call, result: result)
        case "Messages#getMessagesBefore":
            MessagesMethods.getMessagesBefore(call, result: result)
        case "Messages#getMessagesAfter":
            MessagesMethods.getMessagesAfter(call, result: result)
        case "Messages#getLastMessages":
            MessagesMethods.getLastMessages(call, result: result)
        case "Messages#getMessageByIndex":
            MessagesMethods.getMessageByIndex(call, result: result)
        case "Messages#setLastReadMessageIndexWithResult":
            MessagesMethods.setLastReadMessageIndexWithResult(call, result: result)
        case "Messages#advanceLastReadMessageIndexWithResult":
            MessagesMethods.advanceLastReadMessageIndexWithResult(call, result: result)
        case "Messages#setAllMessagesReadWithResult":
            MessagesMethods.setAllMessagesReadWithResult(call, result: result)
        case "Messages#setNoMessagesReadWithResult":
            MessagesMethods.setNoMessagesReadWithResult(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func debug(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let enableNative = arguments["native"] as? Bool else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'native' parameter", details: nil))
        }

        guard let enableSdk = arguments["sdk"] as? Bool else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'sdk' parameter", details: nil))
        }

        SwiftTwilioConversationsPlugin.nativeDebug = enableNative
        if enableSdk {
            TwilioConversationsClient.setLogLevel(TCHLogLevel.debug)
        }
        result(enableNative)
    }

    private func create(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftTwilioConversationsPlugin.debug("TwilioConversationsPlugin.create => called")

        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let token = arguments["token"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'token' parameter", details: nil))
        }

        guard let propertiesObj = arguments["properties"] as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'token' parameter", details: nil))
        }

        let properties = TwilioConversationsClientProperties()
        if let region = propertiesObj["region"] as? String {
            properties.region = region
        }

        let flutterResult = result

        SwiftTwilioConversationsPlugin.chatListener = ChatListener(token, properties)

        TwilioConversationsClient.conversationsClient(withToken: token, properties: properties, delegate: SwiftTwilioConversationsPlugin.chatListener, completion: {(result: TCHResult, chatClient: TwilioConversationsClient?) -> Void in
            if result.isSuccessful {
                SwiftTwilioConversationsPlugin.debug("TwilioConversationsPlugin.create => ChatClient.create onSuccess: myIdentity is '\(chatClient?.user?.identity ?? "unknown")'")
                SwiftTwilioConversationsPlugin.chatListener?.chatClient = chatClient
                flutterResult(Mapper.chatClientToDict(chatClient))
            } else {
                SwiftTwilioConversationsPlugin.debug("TwilioConversationsPlugin.create => ChatClient.create onError: \(String(describing: result.error))")
            }
            } as TCHTwilioClientCompletion)
    }
}
