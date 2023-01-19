package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.ErrorInfo
import com.twilio.conversations.StatusListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import android.util.Log

object ChatClientMethods {
    fun updateToken(call: MethodCall, result: MethodChannel.Result) {
        val token = call.argument<String>("token")
                ?: return result.error("ERROR", "Missing 'token'", null)

        TwilioConversationsPlugin.chatClient?.updateToken(token, object : StatusListener {
            override fun onSuccess() {
                Log.d("TwilioInfo", "ChatClientMethods.updateToken => onSuccess")
                result.success(null)
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "ChatClientMethods.updateToken => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun shutdown(call: MethodCall, result: MethodChannel.Result) {
        return try {
            TwilioConversationsPlugin.chatClient?.shutdown()
            result.success(null)
        } catch (err: Exception) {
            result.error("ERROR", err.message, null)
        }
    }
}
