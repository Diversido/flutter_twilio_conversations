package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.CallbackListener
import com.twilio.util.ErrorInfo
import com.twilio.conversations.User
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import android.util.Log

object UsersMethods {
    fun getChannelUserDescriptors(call: MethodCall, result: MethodChannel.Result) {
        result.success(Mapper.usersToMap(TwilioConversationsPlugin.chatClient?.subscribedUsers!!))
    }

    fun getUserDescriptor(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        TwilioConversationsPlugin.chatClient?.getAndSubscribeUser(identity, object : CallbackListener<User> {
            override fun onSuccess(userDescriptor: User) {
                Log.d("TwilioInfo", "UsersMethods.getUserDescriptor => onSuccess")
                result.success(Mapper.userDescriptorToMap(userDescriptor))
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "UsersMethods.getUserDescriptor => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getAndSubscribeUser(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        TwilioConversationsPlugin.chatClient?.getAndSubscribeUser(identity, object : CallbackListener<User> {
            override fun onSuccess(user: User) {
                Log.d("TwilioInfo", "UsersMethods.getAndSubscribeUser => onSuccess")
                result.success(Mapper.userToMap(user))
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "UsersMethods.getAndSubscribeUser => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }
}
