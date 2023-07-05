package twilio.flutter.twilio_conversations.listeners

import com.twilio.conversations.*
import io.flutter.plugin.common.EventChannel
import twilio.flutter.twilio_conversations.Mapper
import com.twilio.util.ErrorInfo
import android.util.Log

class ChatListener(val properties: ConversationsClient.Properties) : ConversationsClientListener {
    var events: EventChannel.EventSink? = null

    override fun onClientSynchronization(synchronizationStatus: ConversationsClient.SynchronizationStatus) {
        Log.d("TwilioInfo", "ChatListener.onClientSynchronization => status = $synchronizationStatus")
        sendEvent("clientSynchronization", mapOf("synchronizationStatus" to synchronizationStatus.toString()))
    }

    override fun onConversationSynchronizationChange(conversation: Conversation?) {
        Log.d("TwilioInfo", "ChatListener.onConversationSynchronizationChange => conversation = '${conversation?.sid}' ")
        sendEvent("channelSynchronizationChange", mapOf("channel" to Mapper.channelToMap(conversation!!)))
    }

    override fun onConnectionStateChange(connectionState: ConversationsClient.ConnectionState) {
        Log.d("TwilioInfo", "ChatListener.onConnectionStateChange => status = $connectionState")
        sendEvent("connectionStateChange", mapOf("connectionState" to connectionState.toString()))
    }

    override fun onError(errorInfo: ErrorInfo) {
        sendEvent("error", null, errorInfo)
    }

//    override fun onInvitedToChannelNotification(channelSid: String) {
//        Log.d("TwilioInfo", "ChatListener.onInvitedToChannelNotification => channelSid = $channelSid")
//        sendEvent("invitedToChannelNotification", mapOf("channelSid" to channelSid))
//    }

    override fun onNewMessageNotification(channelSid: String?, messageSid: String?, messageIndex: Long) {
        Log.d("TwilioInfo", "ChatListener.onNewMessageNotification => channelSid = $channelSid, messageSid = $messageSid, messageIndex = $messageIndex")
        sendEvent("newMessageNotification", mapOf(
                "channelSid" to channelSid,
                "messageSid" to messageSid,
                "messageIndex" to messageIndex
        ))
    }

    override fun onAddedToConversationNotification(conversationSid: String?) {
        Log.d("TwilioInfo", "ChatListener.onAddedToConversationNotification => added to '${conversationSid}'")
        sendEvent("addedToChannelNotification", mapOf(
            "channelSid" to conversationSid
        ))
    }

    override fun onNotificationSubscribed() {
        Log.d("TwilioInfo", "ChatListener.onNotificationSubscribed")
        sendEvent("notificationSubscribed", null)
    }

    override fun onNotificationFailed(errorInfo: ErrorInfo) {
        sendEvent("notificationFailed", null, errorInfo)
    }

    override fun onTokenAboutToExpire() {
        Log.d("TwilioInfo", "ChatListener.onTokenAboutToExpire")
        sendEvent("tokenAboutToExpire", null)
    }

    override fun onTokenExpired() {
        Log.d("TwilioInfo", "ChatListener.onTokenExpired")
        sendEvent("tokenExpired", null)
    }

    override fun onUserSubscribed(user: User) {
        Log.d("TwilioInfo", "ChatListener.onUserSubscribed => user '${user.friendlyName}'")
        sendEvent("userSubscribed", mapOf("user" to Mapper.userToMap(user)))
    }

    override fun onUserUnsubscribed(user: User) {
        Log.d("TwilioInfo", "ChatListener.onUserUnsubscribed => user '${user.friendlyName}'")
        sendEvent("userUnsubscribed", mapOf("user" to Mapper.userToMap(user)))
    }

    override fun onConversationUpdated(conversation: Conversation?, reason: Conversation.UpdateReason?) {
        Log.d("TwilioInfo", "ChatListener.onConversationUpdated => conversation '${conversation?.sid}' updated, $reason")
        sendEvent("channelUpdated", mapOf(
                "channel" to Mapper.channelToMap(conversation!!),
                "reason" to mapOf(
                    "type" to "channel",
                    "value" to reason.toString()
                )
        ))
    }

    override fun onConversationAdded(conversation: Conversation?) {
        Log.d("TwilioInfo", "ChatListener.onConversationAdded => conversation '${conversation?.sid}' added")
        sendEvent("channelAdded", mapOf(
                "channel" to Mapper.channelToMap(conversation!!)
        ))
    }

    override fun onUserUpdated(user: User, reason: User.UpdateReason) {
        Log.d("TwilioInfo", "ChatListener.onUserUpdated => user '${user.friendlyName}' updated, $reason")
        sendEvent("userUpdated", mapOf(
                "user" to Mapper.userToMap(user),
                "reason" to mapOf(
                        "type" to "user",
                        "value" to reason.toString()
                )
        ))
    }

    override fun onConversationDeleted(conversation: Conversation?) {
        Log.d("TwilioInfo", "ChatListener.onConversationDeleted => conversation '${conversation?.sid}' deleted")
        sendEvent("channelDeleted", mapOf(
            "channel" to Mapper.channelToMap(conversation!!)
        ))
    }

    override fun onRemovedFromConversationNotification(conversationSid: String?) {
        Log.d("TwilioInfo", "ChatListener.onRemovedFromConversationNotification => removed from '${conversationSid}'")
        sendEvent("removedFromChannelNotification", mapOf(
            "channelSid" to conversationSid
        ))
    }

    private fun sendEvent(name: String, data: Any?, e: ErrorInfo? = null) {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        events?.success(eventData)
    }
}
