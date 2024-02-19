package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.FileInputStream
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import com.twilio.util.ErrorInfo
import android.util.Log

object MessagesMethods {
    fun sendMessage(pluginInstance: TwilioConversationsPlugin, call: MethodCall, result: MethodChannel.Result) {
        val options = call.argument<Map<String, Any>>("options")
                ?: return result.error("ERROR", "Missing 'options'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        Log.d("TwilioInfo", "MessagesMethods.sendMessage => started")

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.getChannel) => onSuccess")

                var messagePreparator = channel.prepareMessage()

                if (options["body"] != null) {
                    Log.d("TwilioInfo", "MessagesMethods.sendMessage => Inside set body")
                    messagePreparator.setBody(options["body"] as String)
                }

                if (options["attributes"] != null) {
                    Log.d("TwilioInfo", "MessagesMethods.sendMessage => Inside set attribute")

                    messagePreparator.setAttributes(Mapper.mapToAttributes(options["attributes"] as Map<String, Any>?) as Attributes)
                }

                if(options["input"] != null && options["mimeType"] != null){
                    val inputList = options["input"] as List<String>
                    val mimeTypeList = options["mimeType"] as List<String>
                    val fileName = options["filename"] as List<String>
                    if(inputList.size == mimeTypeList.size && inputList.size == 1){
                        val input = inputList[0] as String
                        val mimeType = mimeTypeList[0] as String?
                                ?: return result.error("ERROR", "Missing 'mimeType' in MessageOptions", null)
                        Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.addMedia) => hasMedia")
                        messagePreparator.addMedia(FileInputStream(input), mimeType, fileName[0] as String, object : MediaUploadListener {
                            override fun onCompleted(mediaSid: String) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onCompleted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "completed"
                                    "data" to mediaSid
                                })
                            }

                            override fun onStarted() {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onStarted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "started"
                                })
                            }

                            override fun onFailed(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onFailed")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        }).buildAndSend(object : CallbackListener<Message> {
                            override fun onSuccess(message: Message) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onSuccess")
                                result.success(Mapper.messageToMap(message))
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    }

                    if(inputList.size == mimeTypeList.size && inputList.size == 2){

                        Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.addMedia) => hasMedia")
                        messagePreparator.addMedia(FileInputStream( inputList[0] as String),  mimeTypeList[0] as String, fileName[0] as String, object : MediaUploadListener {
                            override fun onCompleted(mediaSid: String) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onCompleted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "completed"
                                    "data" to mediaSid
                                })
                            }

                            override fun onStarted() {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onStarted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "started"
                                })
                            }

                            override fun onFailed(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onFailed")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        }).addMedia(FileInputStream( inputList[1] as String),  mimeTypeList[1] as String, fileName[1] as String, object : MediaUploadListener {
                            override fun onCompleted(mediaSid: String) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onCompleted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "completed"
                                    "data" to mediaSid
                                })
                            }

                            override fun onStarted() {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onStarted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "started"
                                })
                            }

                            override fun onFailed(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onFailed")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        }).buildAndSend(object : CallbackListener<Message> {
                            override fun onSuccess(message: Message) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onSuccess")
                                result.success(Mapper.messageToMap(message))
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    }

                    if(inputList.size == mimeTypeList.size && inputList.size == 3){

                        Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.addMedia) => hasMedia")
                        messagePreparator.addMedia(FileInputStream( inputList[0] as String),  mimeTypeList[0] as String, fileName[0] as String, object : MediaUploadListener {
                            override fun onCompleted(mediaSid: String) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onCompleted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "completed"
                                    "data" to mediaSid
                                })
                            }

                            override fun onStarted() {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onStarted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "started"
                                })
                            }

                            override fun onFailed(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onFailed")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        }).addMedia(FileInputStream( inputList[1] as String),  mimeTypeList[1] as String, fileName[1] as String, object : MediaUploadListener {
                            override fun onCompleted(mediaSid: String) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onCompleted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "completed"
                                    "data" to mediaSid
                                })
                            }

                            override fun onStarted() {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onStarted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "started"
                                })
                            }

                            override fun onFailed(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onFailed")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        }).addMedia(FileInputStream( inputList[2] as String),  mimeTypeList[2] as String, fileName[2] as String, object : MediaUploadListener {
                            override fun onCompleted(mediaSid: String) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onCompleted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "completed"
                                    "data" to mediaSid
                                })
                            }

                            override fun onStarted() {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onStarted")
                                pluginInstance.mediaProgressSink?.success({
                                    "mediaProgressListenerId" to options["mediaProgressListenerId"]
                                    "name" to "started"
                                })
                            }

                            override fun onFailed(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.addMedia) => onFailed")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        }).buildAndSend(object : CallbackListener<Message> {
                            override fun onSuccess(message: Message) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onSuccess")
                                result.success(Mapper.messageToMap(message))
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    }
                } else {
                    messagePreparator.buildAndSend(object : CallbackListener<Message> {
                        override fun onSuccess(message: Message) {
                            Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onSuccess")
                            result.success(Mapper.messageToMap(message))
                        }
    
                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "MessagesMethods.sendMessage (Message.sendMessage) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }                
                    })
                }


            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun removeMessage(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)
        val messageIndex = call.argument<Long>("messageIndex")
                ?: return result.error("ERROR", "Missing 'messageIndex'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.removeMessage (Channels.getChannel) => onSuccess")

                channel.getMessageByIndex(messageIndex, object : CallbackListener<Message> {
                    override fun onSuccess(message: Message) {
                        Log.d("TwilioInfo", "MessagesMethods.removeMessage (Messages.getMessageByIndex) => onSuccess")

                        channel.removeMessage(message, object : StatusListener {
                            override fun onSuccess() {
                                Log.d("TwilioInfo", "MessagesMethods.removeMessage (Messages.removeMessage) => onSuccess")
                                result.success(null)
                            }

                            override fun onError(errorInfo: ErrorInfo) {
                                Log.d("TwilioInfo", "MessagesMethods.removeMessage (Messages.removeMessage) => onError: $errorInfo")
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            }
                        })
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.removeMessage (Messages.getMessageByIndex) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getMessagesBefore(call: MethodCall, result: MethodChannel.Result) {
        val index = call.argument<Int>("index")?.toLong()
                ?: return result.error("ERROR", "Missing 'index'", null)
        val count = call.argument<Int>("count")
                ?: return result.error("ERROR", "Missing 'count'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.getMessagesBefore (Channels.getChannel) => onSuccess")

                channel.getMessagesBefore(index, count, object : CallbackListener<List<Message>> {
                    override fun onSuccess(messages: List<Message>) {
                        Log.d("TwilioInfo", "MessagesMethods.getMessagesBefore (Message.getMessagesBefore) => onSuccess")
                        val messagesListMap = messages?.map { Mapper.messageToMap(it) }
                        result.success(messagesListMap)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.getMessagesBefore (Message.getMessagesBefore) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.getMessagesBefore (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getMessagesAfter(call: MethodCall, result: MethodChannel.Result) {
        val index = call.argument<Int>("index")?.toLong()
                ?: return result.error("ERROR", "Missing 'index'", null)
        val count = call.argument<Int>("count")
                ?: return result.error("ERROR", "Missing 'count'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.getMessagesAfter (Channels.getChannel) => onSuccess")

                channel.getMessagesAfter(index, count, object : CallbackListener<List<Message>> {
                    override fun onSuccess(messages: List<Message>) {
                        Log.d("TwilioInfo", "MessagesMethods.getMessagesAfter (Message.getMessagesAfter) => onSuccess")
                        val messagesListMap = messages?.map { Mapper.messageToMap(it) }
                        result.success(messagesListMap)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.getMessagesAfter (Message.getMessagesAfter) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.getMessagesAfter (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getLastMessages(call: MethodCall, result: MethodChannel.Result) {
        val count = call.argument<Int>("count")
                ?: return result.error("ERROR", "Missing 'count'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.getLastMessages (Channels.getChannel) => onSuccess")

                try {
                    channel.getLastMessages(count, object : CallbackListener<List<Message>> {
                        override fun onSuccess(messages: List<Message>) {
                            Log.d("TwilioInfo", "MessagesMethods.getLastMessages (Message.getLastMessages) => onSuccess")
                            val messagesListMap = messages.map { Mapper.messageToMap(it) }
                            result.success(messagesListMap)
                        }
    
                        override fun onError(errorInfo: ErrorInfo) {
                            Log.d("TwilioInfo", "MessagesMethods.getLastMessages (Message.getLastMessages) => onError: $errorInfo")
                            result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                        }
                    })
                } catch (e1: Exception) {
                    result.error("ERR", "$e1", "")
                }
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.getLastMessages (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getMessageByIndex(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)
        val messageIndex = call.argument<Int>("messageIndex")?.toLong()
                ?: return result.error("ERROR", "Missing 'messageIndex'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.getMessageByIndex (Channels.getChannel) => onSuccess")

                channel.getMessageByIndex(messageIndex, object : CallbackListener<Message> {
                    override fun onSuccess(message: Message) {
                        Log.d("TwilioInfo", "MessagesMethods.getMessageByIndex (Message.getMessageByIndex) => onSuccess")
                        result.success(Mapper.messageToMap(message))
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.getMessageByIndex (Message.getMessageByIndex) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.getMessageByIndex (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun setLastReadMessageIndexWithResult(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)
        val lastReadMessageIndex = call.argument<Int>("lastReadMessageIndex")?.toLong()
                ?: return result.error("ERROR", "Missing 'lastReadMessageIndex'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.setLastReadMessageIndexWithResult (Channels.getChannel) => onSuccess")

                channel.setLastReadMessageIndex(lastReadMessageIndex, object : CallbackListener<Long> {
                    override fun onSuccess(newIndex: Long) {
                        Log.d("TwilioInfo", "MessagesMethods.setLastReadMessageIndexWithResult (Message.setLastReadMessageIndexWithResult) => onSuccess: $newIndex")
                        result.success(newIndex)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.setLastReadMessageIndexWithResult (Message.setLastReadMessageIndexWithResult) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.setLastReadMessageIndexWithResult (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun advanceLastReadMessageIndexWithResult(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)
        val lastReadMessageIndex = call.argument<Long>("lastReadMessageIndex")
                ?: return result.error("ERROR", "Missing 'lastReadMessageIndex'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.advanceLastReadMessageIndexWithResult (Channels.getChannel) => onSuccess")

                channel.advanceLastReadMessageIndex(lastReadMessageIndex, object : CallbackListener<Long> {
                    override fun onSuccess(newIndex: Long) {
                        Log.d("TwilioInfo", "MessagesMethods.advanceLastReadMessageIndexWithResult (Message.advanceLastReadMessageIndexWithResult) => onSuccess: $newIndex")
                        result.success(newIndex)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.advanceLastReadMessageIndexWithResult (Message.advanceLastReadMessageIndexWithResult) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.advanceLastReadMessageIndexWithResult (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun setAllMessagesReadWithResult(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.setAllMessagesReadWithResult (Channels.getChannel) => onSuccess")

                channel.setAllMessagesRead(object : CallbackListener<Long> {
                    override fun onSuccess(index: Long) {
                        Log.d("TwilioInfo", "MessagesMethods.setAllMessagesReadWithResult (Message.setAllMessagesReadWithResult) => onSuccess: $index")
                        result.success(index)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.setAllMessagesReadWithResult (Message.setAllMessagesReadWithResult) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.setAllMessagesReadWithResult (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun setNoMessagesReadWithResult(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.setNoMessagesReadWithResult (Channels.getChannel) => onSuccess")

                channel.setAllMessagesUnread(object : CallbackListener<Long> {
                    override fun onSuccess(index: Long) {
                        Log.d("TwilioInfo", "MessagesMethods.setNoMessagesReadWithResult (Message.setNoMessagesReadWithResult) => onSuccess: $index")
                        result.success(index)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MessagesMethods.setNoMessagesReadWithResult (Message.setNoMessagesReadWithResult) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessagesMethods.setNoMessagesReadWithResult (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }
}
