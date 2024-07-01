import Flutter
import TwilioConversationsClient

public class ChannelListener: NSObject, TCHConversationDelegate {
    let events: FlutterEventSink

    init(_ events: @escaping FlutterEventSink) {
        self.events = events
    }

    // onMessageAdded
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, messageAdded message: TCHMessage) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onMessageAdded => messageSid = \(String(describing: message.sid))")
        sendEvent("messageAdded", data: [
            "message": Mapper.messageToDict(message, channelSid: conversation.sid)
        ])
    }

    // onMessageUpdated
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, message: TCHMessage, updated: TCHMessageUpdate) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onMessageUpdated => messageSid = \(String(describing: message.sid)), " +
            "updated = \(String(describing: updated))")
        sendEvent("messageUpdated", data: [
            "message": Mapper.messageToDict(message, channelSid: conversation.sid),
            "reason": [
                "type": "message",
                "value": Mapper.messageUpdateToString(updated)
            ]
        ])
    }

    // onMessageDeleted
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, messageDeleted message: TCHMessage) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onMessageDeleted => messageSid = \(String(describing: message.sid))")
        sendEvent("messageDeleted", data: [
            "message": Mapper.messageToDict(message, channelSid: conversation.sid)
        ])
    }

    // onMemberAdded
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, participantJoined participant: TCHParticipant) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onMemberAdded => memberSid = \(String(describing: participant.sid))")
        sendEvent("memberAdded", data: [
            "member": Mapper.memberToDict(participant, channelSid: conversation.sid) as Any
        ])
    }

    // onMemberUpdated
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, participant: TCHParticipant, updated: TCHParticipantUpdate) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onMemberUpdated => memberSid = \(String(describing: participant.sid)), " +
            "updated = \(String(describing: updated))")
        sendEvent("memberUpdated", data: [
            "member": Mapper.memberToDict(participant, channelSid: conversation.sid) as Any,
            "reason": [
                "type": "member",
                "value": Mapper.memberUpdateToString(updated)
            ]
        ])
    }

    // onMemberDeleted
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, participantLeft participant: TCHParticipant) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onMemberDeleted => memberSid = \(String(describing: participant.sid))")
        sendEvent("memberDeleted", data: [
            "member": Mapper.memberToDict(participant, channelSid: conversation.sid) as Any
        ])
    }

    // onTypingStarted
    public func conversationsClient(_ client: TwilioConversationsClient, typingStartedOn conversation: TCHConversation, participant: TCHParticipant) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onTypingStarted => channelSid = \(String(describing: conversation.sid)), " +
            "memberSid = \(String(describing: participant.sid))")
        sendEvent("typingStarted", data: [
            "channel": Mapper.channelToDict(conversation) as Any,
            "member": Mapper.memberToDict(participant, channelSid: conversation.sid) as Any
        ])
    }

    // onTypingEnded
    public func conversationsClient(_ client: TwilioConversationsClient, typingEndedOn conversation: TCHConversation, participant: TCHParticipant)  {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onTypingEnded => channelSid = \(String(describing: conversation.sid)), " +
            "memberSid = \(String(describing: participant.sid))")
        sendEvent("typingEnded", data: [
            "channel": Mapper.channelToDict(conversation) as Any,
            "member": Mapper.memberToDict(participant, channelSid: conversation.sid) as Any
        ])
    }

    // onSynchronizationChanged
    public func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation,
        synchronizationStatusUpdated status: TCHConversationSynchronizationStatus) {
        SwiftTwilioConversationsPlugin.debug(
            "ChannelListener.onSynchronizationChanged => channelSid = \(String(describing: conversation.sid))")
        sendEvent("synchronizationChanged", data: [
            "channel": Mapper.channelToDict(conversation) as Any
        ])
    }

    private func sendEvent(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = [
            "name": name,
            "data": data,
            "error": Mapper.errorToDict(error)
            ] as [String: Any?]

        events(eventData)
    }
}
