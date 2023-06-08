import Flutter
import Foundation
import TwilioConversationsClient

public class ChatListener: NSObject, TwilioConversationsClientDelegate {
    public var events: FlutterEventSink?

    public var clientProperties: TwilioConversationsClientProperties

    public var chatClient: TwilioConversationsClient?

    init(_ token: String, _ properties: TwilioConversationsClientProperties) {
        self.clientProperties = properties
    }

    // onAddedToChannel Notification
    public func conversationsClient(_ client: TwilioConversationsClient, notificationAddedToConversationWithSid channelSid: String) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onAddedToChannelNotification => channelSid is \(channelSid)'")
        sendEvent("addedToChannelNotification", data: ["channelSid": channelSid])
    }

    // onChannelAdded
    public func conversationsClient(_ client: TwilioConversationsClient, conversationAdded channel: TCHConversation) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.conversationAdded => channelSid is \(String(describing: channel.sid))'")
        sendEvent("channelAdded", data: ["channel": Mapper.channelToDict(channel) as Any])
    }

    // onChannelDeleted
    public func conversationsClient(_ client: TwilioConversationsClient, conversationDeleted channel: TCHConversation) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.conversationDeleted => channelSid is \(String(describing: channel.sid))'")
        sendEvent("channelDeleted", data: ["channel": Mapper.channelToDict(channel) as Any])
    }

    // onChannelSynchronizationChanged
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, synchronizationStatusUpdated status: TCHConversationSynchronizationStatus) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onChannelSynchronizationChange => channelSid is '\(String(describing: conversation.sid))', syncStatus: \(Mapper.channelSynchronizationStatusToString(conversation.synchronizationStatus))")
        sendEvent("channelSynchronizationChange", data: ["channel": Mapper.channelToDict(conversation) as Any])
    }

    // onChannelUpdated
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, updated: TCHConversationUpdate) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.channelUpdated => channelSid is \(String(describing: conversation.sid)) updated, \(Mapper.channelUpdateToString(updated))")
        sendEvent("channelUpdated", data: [
            "channel": Mapper.channelToDict(conversation) as Any,
            "reason": [
                "type": "channel",
                "value": Mapper.channelUpdateToString(updated)
            ]
        ])
    }

    // onClientSynchronizationUpdated
    public func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onClientSynchronization => state is \(Mapper.clientSynchronizationStatusToString(status))")
        sendEvent("clientSynchronization", data: ["synchronizationStatus": Mapper.clientSynchronizationStatusToString(status)])
    }

    // onConnectionStateChange
    public func conversationsClient(_ client: TwilioConversationsClient, connectionStateUpdated state: TCHClientConnectionState) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onConnectionStateChange => state is \(Mapper.clientConnectionStateToString(state))")
        sendEvent("connectionStateChange", data: ["connectionState": Mapper.clientConnectionStateToString(state)])
    }

    // onError
    public func conversationsClient(_ client: TwilioConversationsClient, errorReceived error: TCHError) {
        sendEvent("error", error: error)
    }

    // onInvitedToChannelNotification
    public func conversationsClient(_ client: TwilioConversationsClient, notificationInvitedToChannelWithSid channelSid: String) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onInvitedToChannelNotification => channelSid is \(channelSid)")
        sendEvent("invitedToChannelNotification", data: ["channelSid": channelSid])
    }

    // onNewMessageNotification
    public func conversationsClient(_ client: TwilioConversationsClient, notificationNewMessageReceivedForConversationSid channelSid: String, messageIndex: UInt) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onNewMessageNotification => channelSid: \(channelSid), messageIndex: \(messageIndex)")
        var messageSid: String = ""
        client.conversation(withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHConversation?) in
            if result.isSuccessful, let channel = channel {
                channel.message(withIndex: messageIndex as NSNumber, completion: { (result: TCHResult, message: TCHMessage?) in
                    if result.isSuccessful, let sid = message?.sid {
                        messageSid = sid
                    }
                })
            }
        })
        sendEvent("newMessageNotification", data: [
            "channelSid": channelSid,
            "messageSid": messageSid,
            "messageIndex": messageIndex
        ])
    }


    // onRemovedFromChannelNotification
    public func conversationsClient(_ client: TwilioConversationsClient, notificationRemovedFromConversationWithSid channelSid: String) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onRemovedFromChannelNotification => channelSid: \(channelSid)")
        sendEvent("removedFromChannelNotification", data: ["channelSid": channelSid])
    }

    // onTokenAboutToExpire
    public func conversationsClientTokenWillExpire(_ client: TwilioConversationsClient) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onTokenAboutToExpire")
        sendEvent("tokenAboutToExpire", data: nil)
    }

    // onTokenExpired
    public func conversationsClientTokenExpired(_ client: TwilioConversationsClient) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onTokenExpired")
        sendEvent("tokenExpired", data: nil)
    }

    // onUserSubscribed
    public func conversationsClient(_ client: TwilioConversationsClient, userSubscribed user: TCHUser) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onUserSubscribed => user '\(String(describing: user.identity))'")
        sendEvent("userSubscribed", data: ["user": Mapper.userToDict(user) as Any])
    }

    // onUserUnsubscribed
    public func conversationsClient(_ client: TwilioConversationsClient, userUnsubscribed user: TCHUser) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onUserUnsubscribed => user '\(String(describing: user.identity))'")
        sendEvent("userUnsubscribed", data: ["user": Mapper.userToDict(user) as Any])
    }

    // onUserUpdated
    public func conversationsClient(_ client: TwilioConversationsClient, user: TCHUser, updated: TCHUserUpdate) {
        SwiftTwilioConversationsPlugin.debug("ChatListener.onUserUpdated => user \(String(describing: user.identity)) updated, \(Mapper.userUpdateToString(updated))")
        sendEvent("userUpdated", data: [
            "user": Mapper.userToDict(user) as Any,
            "reason": [
                "type": "user",
                "value": Mapper.userUpdateToString(updated)
            ]
        ])
    }

    private func errorToDict(_ error: Error?) -> [String: Any]? {
        if let error = error as NSError? {
            return [
                "code": error.code,
                "message": error.description
            ]
        }
        return nil
    }

    private func sendEvent(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": errorToDict(error)] as [String: Any?]

        if let events = events {
            events(eventData)
        }
    }
}
