package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.twilio.util.ErrorInfo
import org.json.JSONException
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import android.util.Log

object MessageMethods {
    fun getChannel(pluginInstance: TwilioConversationsPlugin, call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessageMethods.getChannel => onSuccess")
                result.success(Mapper.channelToMap(pluginInstance, channel))
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessageMethods.getChannel => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun updateMessageBody(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val messageIndex = call.argument<Int>("messageIndex")?.toLong()
                ?: return result.error("ERROR", "Missing 'messageIndex'", null)

        val body = call.argument<String>("body")
                ?: return result.error("ERROR", "Missing 'body'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Channels.getChannel) => onSuccess")

                channel.getMessageByIndex(messageIndex, object : CallbackListener<Message> {
                    override fun onSuccess(message: Message) {
                        Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Messages.getMessageByIndex) => onSuccess")

                        message.updateBody(body, object : StatusListener {
                            override fun onSuccess() {
                                Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Message.updateMessageBody) => onSuccess")
                                result.success(message.getBody())
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Message.updateMessageBody) => onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Messages.getMessageByIndex) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun setAttributes(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val messageIndex = call.argument<Int>("messageIndex")?.toLong()
                ?: return result.error("ERROR", "Missing 'messageIndex'", null)

        // Not erroring out because a nullable attributes is allowed to reset the Channel attributes.
        val attributes = call.argument<Map<String, Any>>("attributes")

        try {
            TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "MessageMethods.setAttributes => onSuccess")

                    channel.getMessageByIndex(messageIndex, object : CallbackListener<Message> {
                        override fun onSuccess(message: Message) {
                            Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Messages.getMessageByIndex) => onSuccess")
                            message.setAttributes(Mapper.mapToAttributes(attributes) as Attributes, object : StatusListener {
                                override fun onSuccess() {
                                    Log.d("TwilioInfo", "MessageMethods.setAttributes  (Channel.setAttributes) => onSuccess")
                                    try {
                                        result.success(Mapper.attributesToMap(message.attributes))
                                    } catch (err: JSONException) {
                                        return result.error("JSONException", err.message, null)
                                    }
                                }

                                override fun onError(errorInfo: ErrorInfo) {
                                    Log.d("TwilioInfo", "MessageMethods.setAttributes  (Channel.setAttributes) => onError: $errorInfo")
                                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                                }
                            })
                            try {
                                result.success(Mapper.attributesToMap(message.attributes))
                            } catch (err: JSONException) {
                                return result.error("JSONException", err.message, null)
                            }
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Messages.getMessageByIndex) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "MessageMethods.setAttributes => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
        } catch (err: IllegalArgumentException) {
            return result.error("IllegalArgumentException", err.message, null)
        }
    }

    fun getMedia(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val messageIndex = call.argument<Int>("messageIndex")?.toLong()
                ?: return result.error("ERROR", "Missing 'messageIndex'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
                override fun onSuccess(channel: Conversation) {
                    Log.d("TwilioInfo", "MessageMethods.getMedia => onSuccess")
                    channel.getMessageByIndex(messageIndex, object : CallbackListener<Message> {
                        override fun onSuccess(message: Message) {
                            Log.d("TwilioInfo", "MessageMethods.getAllAttachedMedia (Messages.getMessageByIndex) => onSuccess")

                            val newmediaList = message.getAttachedMedia()

                            if (newmediaList != null && newmediaList.isNotEmpty()) {
                                message.getTemporaryContentUrlsForMedia(newmediaList, object : CallbackListener<Map<String, String>> {
                                    override fun onSuccess(fileUrls: Map<String, String>) {
                                        Log.d("TwilioInfo", "MessageMethods.getAllAttachedMedia => onSuccess")
                                        val mediaSids = fileUrls.values.toList()

                                        Log.d("TwilioInfo", "Media SIDs: $mediaSids")

                                        result.success(mediaSids)
                                    }

                                    override fun onError(errorInfo: ErrorInfo) {
                                        Log.d("TwilioInfo", "MessageMethods.getAllAttachedMedia => onError: $errorInfo")
                                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                                    }
                                })
                            } else {
                                result.error("ERROR", "No attached media found for the specified message", null)
                            }
//                            Log.d("TwilioInfo", "MessageMethods.getMedia (Messages.getMessageByIndex) => onSuccess")
//                            message.getTemporaryContentUrlsForAttachedMedia(object : CallbackListener<Map<String, String>> {
//                                override fun onSuccess(fileUrls: Map<String, String>) {
//                                    Log.d("TwilioInfo", "MessageMethods.getMedia (Message.Media.download) => onSuccess")
//                                    result.success(fileUrls[fileUrls.keys.first()] as String)
//                                }
//
//                                override fun onError(errorInfo: ErrorInfo) {
//                                    Log.d("TwilioInfo", "MessageMethods.getMedia (Message.Media.download) => onError: $errorInfo")
//                                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
//                                }
//                            })
                        }

                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Messages.getMessageByIndex) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                }

                override fun onError(errorInfo: ErrorInfo) {
                    Log.d("TwilioInfo", "MessageMethods.getMedia => onError: $errorInfo")
                    result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                }
            })
    }
}
