package twilio.flutter.twilio_conversations.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin

object UserMethods {
    fun unsubscribe(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        try {
            val subscribedUser = TwilioConversationsPlugin.chatClient?.subscribedUsers?.find { it.identity == identity }

            if (subscribedUser != null) {
                subscribedUser.unsubscribe()
            } else {
                return result.error("ERROR", "No subscribed user found with the identity '$identity'", null)
            }
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }
}
