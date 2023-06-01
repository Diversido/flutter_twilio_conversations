package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import com.twilio.util.ErrorInfo
import android.util.Log

object MemberMethods {
    fun getChannel(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MemberMethods.getChannel => onSuccess")
                result.success(Mapper.channelToMap(channel))
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MemberMethods.getChannel => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getUserDescriptor(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "MemberMethods.getUserDescriptor => onSuccess")
                    val member = channel.participantsList.find { it.identity == identity }
                    if (member != null) {
                        member.getAndSubscribeUser(object : CallbackListener<User> {
                            override fun onSuccess(userDescriptor: User) {
                                Log.d("TwilioInfo", "MemberMethods.getUserDescriptor (Member.getUserDescriptor) => onSuccess")
                                result.success(Mapper.userDescriptorToMap(userDescriptor))
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "ChannelsMethods.getUserDescriptor => getUserDescriptor onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    } else {
                        return result.error("ERROR", "No member found on channel '$channelSid' with identity '$identity'", null)
                    }
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelsMethods.getUserDescriptor => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getAndSubscribeUser(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val memberSid = call.argument<String>("memberSid")
                ?: return result.error("ERROR", "Missing 'memberSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "MemberMethods.getAndSubscribeUser => onSuccess")
                    val member = channel.participantsList.find { it.sid == memberSid }
                    if (member != null) {
                        member.getAndSubscribeUser(object : CallbackListener<User> {
                            override fun onSuccess(user: User) {
                                Log.d("TwilioInfo", "MemberMethods.getAndSubscribeUser (Member.getAndSubscribeUser) => onSuccess")
                                result.success(Mapper.userToMap(user))
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "ChannelsMethods.getAndSubscribeUser => getAndSubscribeUser onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    } else {
                        return result.error("ERROR", "No member found on channel '$channelSid' with sid '$memberSid'", null)
                    }
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelsMethods.getAndSubscribeUser => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun setAttributes(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val memberSid = call.argument<String>("memberSid")
                ?: return result.error("ERROR", "Missing 'memberSid'", null)

        // Not erroring out because a nullable attributes is allowed to reset the Channel attributes.
        val attributes = call.argument<Map<String, Any>>("attributes")

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "MemberMethods.setAttributes => onSuccess")
                    val member = channel.participantsList.find { it.sid == memberSid }
                    if (member != null) {
                        member.setAttributes(Mapper.mapToAttributes(attributes) as Attributes, object : StatusListener {
                            override fun onSuccess() {
                                Log.d("TwilioInfo", "MemberMethods.setAttributes  (Channel.setAttributes) => onSuccess")
                                try {
                                    result.success(Mapper.attributesToMap(member.attributes))
                                } catch (err: JSONException) {
                                    return result.error("JSONException", err.message, null)
                                }
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MemberMethods.setAttributes  (Channel.setAttributes) => onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    } else {
                        return result.error("ERROR", "No member found on channel '$channelSid' with sid '$memberSid'", null)
                    }
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "MemberMethods.setAttributes => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }
}
