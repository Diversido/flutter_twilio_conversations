package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.*
import com.twilio.conversations.CallbackListener
import com.twilio.conversations.Conversation
import com.twilio.util.ErrorInfo
import com.twilio.conversations.StatusListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import android.util.Log

object ChannelMethods {
    fun join(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.join => onSuccess")
                    channel.join(object : StatusListener {
                        override fun onSuccess() {
                            Log.d("TwilioInfo", "ChannelMethods.join (Channel.join) => onSuccess")
                            result.success(null)
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.join (Channel.join) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.join => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun leave(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.leave => onSuccess")
                    channel.leave(object : StatusListener {
                        override fun onSuccess() {
                            Log.d("TwilioInfo", "ChannelMethods.leave (Channel.leave) => onSuccess")
                            result.success(null)
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.leave (Channel.leave) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.leave => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun typing(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.typing => onSuccess")
                    channel.typing()
                    result.success(null)
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.typing => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun destroy(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.destroy => onSuccess")
                    channel.destroy(object : StatusListener {
                        override fun onSuccess() {
                            Log.d("TwilioInfo", "ChannelMethods.destroy (Channel.destroy) => onSuccess")
                            result.success(null)
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.destroy (Channel.destroy) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.destroy => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getMessagesCount(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.getMessagesCount => onSuccess")
                    channel.getMessagesCount(object : CallbackListener<Long> {
                        override fun onSuccess(messageCount: Long) {
                            Log.d("TwilioInfo", "ChannelMethods.getMessagesCount (Channel.getMessagesCount) => onSuccess: $messageCount")
                            result.success(messageCount)
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.getMessagesCount (Channel.getMessagesCount) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.getMessagesCount => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getUnreadMessagesCount(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.getUnreadMessagesCount => onSuccess")
                    channel.getUnreadMessagesCount {
                        Log.d("TwilioInfo", "ChannelMethods.getUnreadMessagesCount (Channel.getUnreadMessagesCount) => onSuccess: $it")
                        result.success(it)
                    }
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.getUnreadMessagesCount => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getMembersCount(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.getMembersCount (Channel.getMembersCount) => onSuccess: ${channel.participantsList.size}")
                    result.success(channel.participantsList.size)
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.getMembersCount => onError: $errorInfo")
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

        // Not erroring out because a nullable attributes is allowed to reset the Channel attributes.
        val attributes = call.argument<Map<String, Any>>("attributes")

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.setAttributes => onSuccess")
                    channel.setAttributes(Mapper.mapToAttributes(attributes) as Attributes, object : StatusListener {
                        override fun onSuccess() {
                            Log.d("TwilioInfo", "ChannelMethods.setAttributes  (Channel.setAttributes) => onSuccess")
                            try {
                                result.success(Mapper.attributesToMap(channel.attributes))
                            } catch (err: JSONException) {
                                return result.error("JSONException", err.message, null)
                            }
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.setAttributes  (Channel.setAttributes) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.setAttributes => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getFriendlyName(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.getFriendlyName => onSuccess")
                    result.success(channel.friendlyName)
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.getFriendlyName => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun setFriendlyName(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val friendlyName = call.argument<String>("friendlyName")
                ?: return result.error("ERROR", "Missing 'friendlyName'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.setFriendlyName => onSuccess")
                    channel.setFriendlyName(friendlyName, object : StatusListener {
                        override fun onSuccess() {
                            Log.d("TwilioInfo", "ChannelMethods.setFriendlyName  (Channel.setFriendlyName) => onSuccess")
                            result.success(channel.friendlyName)
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.setFriendlyName  (Channel.setFriendlyName) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.setFriendlyName => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getNotificationLevel(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.getNotificationLevel => onSuccess")
                    result.success(channel.notificationLevel.toString())
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.getNotificationLevel => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun setNotificationLevel(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val notificationLevelValue = call.argument<String>("notificationLevel")
                ?: return result.error("ERROR", "Missing 'notificationLevel'", null)

        val notificationLevel = when (notificationLevelValue) {
            "DEFAULT" -> Conversation.NotificationLevel.DEFAULT
            "MUTED" -> Conversation.NotificationLevel.MUTED
            else -> null
        } ?: return result.error("ERROR", "Wrong value for 'notificationLevel'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.setNotificationLevel => onSuccess")
                    channel.setNotificationLevel(notificationLevel, object : StatusListener {
                        override fun onSuccess() {
                            Log.d("TwilioInfo", "ChannelMethods.setNotificationLevel  (Channel.setNotificationLevel) => onSuccess")
                            result.success(channel.notificationLevel.toString())
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.setNotificationLevel  (Channel.setNotificationLevel) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.setAttributes => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getUniqueName(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.getUniqueName => onSuccess")
                    result.success(channel.uniqueName)
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.getUniqueName => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun setUniqueName(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val uniqueName = call.argument<String>("uniqueName")
                ?: return result.error("ERROR", "Missing 'uniqueName'", null)

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "ChannelMethods.setUniqueName => onSuccess")
                    channel.setUniqueName(uniqueName, object : StatusListener {
                        override fun onSuccess() {
                            Log.d("TwilioInfo", "ChannelMethods.setUniqueName  (Channel.setUniqueName) => onSuccess")
                            result.success(channel.uniqueName)
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "ChannelMethods.setUniqueName  (Channel.setUniqueName) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "ChannelMethods.setUniqueName => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }
}
