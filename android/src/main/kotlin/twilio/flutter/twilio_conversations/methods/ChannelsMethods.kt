package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.CallbackListener
import com.twilio.conversations.Conversation
import com.twilio.util.ErrorInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import android.util.Log

object ChannelsMethods {

    fun getChannel(call: MethodCall, result: MethodChannel.Result) {
        val channelSidOrUniqueName = call.argument<String>("channelSidOrUniqueName")
                ?: return result.error("ERROR", "Missing 'channelSidOrUniqueName'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSidOrUniqueName, object : CallbackListener<Conversation> {
            override fun onSuccess(newChannel: Conversation) {
                Log.d("TwilioInfo", "ChannelsMethods.getChannel => onSuccess")
                result.success(Mapper.channelToMap(newChannel))
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "ChannelsMethods.getChannel => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getPublicChannelsList(call: MethodCall, result: MethodChannel.Result) {
        result.success(TwilioConversationsPlugin.chatClient?.myConversations)
    }

    fun getUserChannelsList(call: MethodCall, result: MethodChannel.Result) {
        result.success(TwilioConversationsPlugin.chatClient?.myConversations)
    }
}
