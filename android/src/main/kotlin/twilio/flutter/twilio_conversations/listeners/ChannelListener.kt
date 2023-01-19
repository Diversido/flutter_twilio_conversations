package twilio.flutter.twilio_conversations.listeners

import com.twilio.conversations.*
import com.twilio.conversations.ConversationListener as TwilioChannelListener
import io.flutter.plugin.common.EventChannel
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import android.util.Log

class ChannelListener(private val events: EventChannel.EventSink) : TwilioChannelListener {
    override fun onMessageAdded(message: Message) {
        Log.d("TwilioInfo", "ChannelListener.onMessageAdded => messageSid = ${message.sid}")
        sendEvent("messageAdded", mapOf("message" to Mapper.messageToMap(message)))
    }

    override fun onMessageUpdated(message: Message?, reason: Message.UpdateReason?) {
        if (message != null) {
            Log.d("TwilioInfo", "ChannelListener.onMessageUpdated => messageSid = ${message.sid}, reason = $reason")
            sendEvent("messageUpdated", mapOf(
                    "message" to Mapper.messageToMap(message),
                    "reason" to mapOf(
                            "type" to "message",
                            "value" to reason.toString()
                    )
            ))
        }
    }

    override fun onMessageDeleted(message: Message) {
        Log.d("TwilioInfo", "ChannelListener.onMessageDeleted => messageSid = ${message.sid}")
        sendEvent("messageDeleted", mapOf("message" to Mapper.messageToMap(message)))
    }

    override fun onParticipantAdded(member: Participant) {
        Log.d("TwilioInfo", "ChannelListener.onMemberAdded => memberSid = ${member.sid}")
        sendEvent("memberAdded", mapOf("member" to Mapper.memberToMap(member)))
    }

    override fun onParticipantUpdated(member: Participant, reason: Participant.UpdateReason) {
        Log.d("TwilioInfo", "ChannelListener.onMemberUpdated => memberSid = ${member.sid}, reason = $reason")
        sendEvent("memberUpdated", mapOf(
                "member" to Mapper.memberToMap(member),
                "reason" to mapOf(
                        "type" to "member",
                        "value" to reason.toString()
                )
        ))
    }

    override fun onParticipantDeleted(member: Participant) {
        Log.d("TwilioInfo", "ChannelListener.onMemberDeleted => memberSid = ${member.sid}")
        sendEvent("memberDeleted", mapOf("member" to Mapper.memberToMap(member)))
    }

    override fun onTypingStarted(channel: Conversation, member: Participant) {
        Log.d("TwilioInfo", "ChannelListener.onTypingStarted => channelSid = ${channel.sid}, memberSid = ${member.sid}")
        sendEvent("typingStarted", mapOf("channel" to Mapper.channelToMap(channel), "member" to Mapper.memberToMap(member)))
    }

    override fun onTypingEnded(channel: Conversation, member: Participant) {
        Log.d("TwilioInfo", "ChannelListener.onTypingEnded => channelSid = ${channel.sid}, memberSid = ${member.sid}")
        sendEvent("typingEnded", mapOf("channel" to Mapper.channelToMap(channel), "member" to Mapper.memberToMap(member)))
    }

    override fun onSynchronizationChanged(channel: Conversation) {
        Log.d("TwilioInfo", "ChannelListener.onSynchronizationChanged => channelSid = ${channel.sid}")
        sendEvent("synchronizationChanged", mapOf("channel" to Mapper.channelToMap(channel)))
    }

    private fun sendEvent(name: String, data: Any?, e: ErrorInfo? = null) {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        events.success(eventData)
    }
}
