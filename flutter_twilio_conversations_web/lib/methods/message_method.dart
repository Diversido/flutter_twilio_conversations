import 'dart:js_util';

import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';

class MessageMethods {
  @override
  Future<dynamic> getLastMessages(int count, Channel _channel,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    // check channel exists
    // confused as to why we use this to get messages????
    // chatclient get conversation
    //channel get lastmessages???
    final channels =
        await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
      _chatClient!.getSubscribedConversations(),
    );

    final messages =
        await promiseToFuture<JSPaginator<TwilioConversationsMessage>>(channels
            .items
            .firstWhere((element) => element.sid == _channel.sid)
            .getMessages());

    final messageList = await Future.wait(
        messages.items.map((message) => Mapper.messageToMap(message)));
    return messageList;
  }

  @override
  Future<dynamic> sendMessage(MessageOptions options, Channel _channel) async {}
}

/*val options = call.argument<Map<String, Any>>("options")
                ?: return result.error("ERROR", "Missing 'options'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        Log.d("TwilioInfo", "MessagesMethods.sendMessage => started")

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.getChannel) => onSuccess")

                var messagePreparator = channel.prepareMessage()

                if (options["body"] != null) {
                    messagePreparator.setBody(options["body"] as String)
                }

                if (options["attributes"] != null) {
                    messagePreparator.setAttributes(Mapper.mapToAttributes(options["attributes"] as Map<String, Any>?) as Attributes)
                }

                if (options["input"] != null && (options["mimeType"] as String?) != null) {
                    val input = options["input"] as String
                    val mimeType = options["mimeType"] as String?
                            ?: return result.error("ERROR", "Missing 'mimeType' in MessageOptions", null)
                            Log.d("TwilioInfo", "MessagesMethods.sendMessage (Channels.addMedia) => hasMedia")
                            channel.prepareMessage().addMedia(FileInputStream(input), mimeType, "image.jpeg", object : MediaUploadListener {
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
        }) */