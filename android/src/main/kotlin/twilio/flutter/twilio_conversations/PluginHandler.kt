package twilio.flutter.twilio_conversations

import android.content.Context
import androidx.annotation.NonNull
import android.util.Log
import com.twilio.conversations.CallbackListener
import com.twilio.conversations.ConversationsClient
import com.twilio.util.ErrorInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import twilio.flutter.twilio_conversations.listeners.ChatListener
import twilio.flutter.twilio_conversations.methods.ChannelMethods
import twilio.flutter.twilio_conversations.methods.ChannelsMethods
import twilio.flutter.twilio_conversations.methods.ChatClientMethods
import twilio.flutter.twilio_conversations.methods.MemberMethods
import twilio.flutter.twilio_conversations.methods.MembersMethods
import twilio.flutter.twilio_conversations.methods.MessageMethods
import twilio.flutter.twilio_conversations.methods.MessagesMethods
import twilio.flutter.twilio_conversations.methods.UserMethods
import twilio.flutter.twilio_conversations.methods.UsersMethods
import java.util.*
import kotlin.concurrent.schedule

class PluginHandler(private val applicationContext: Context) : MethodCallHandler {

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        Log.d("TwilioInfo", "TwilioConversationsPlugin.onMethodCall => received ${call.method}")
        if (call.method != "cancel" && call.method != "listen") {
            when (call.method) {
                "debug" -> debug(call, result)
                "create" -> create(call, result)
                "registerForNotification" -> TwilioConversationsPlugin.instance.registerForNotification(call, result)
                "unregisterForNotification" -> TwilioConversationsPlugin.instance.unregisterForNotification(call, result)
    
                "ChatClient#updateToken" -> ChatClientMethods.updateToken(call, result)
                "ChatClient#shutdown" -> ChatClientMethods.shutdown(call, result)
    
                "User#unsubscribe" -> UserMethods.unsubscribe(call, result)
    
                "Users#getChannelUserDescriptors" -> UsersMethods.getChannelUserDescriptors(call, result)
                "Users#getUserDescriptor" -> UsersMethods.getUserDescriptor(call, result)
                "Users#getAndSubscribeUser" -> UsersMethods.getAndSubscribeUser(call, result)
    
                "Channel#join" -> ChannelMethods.join(call, result)
                "Channel#leave" -> ChannelMethods.leave(call, result)
                "Channel#typing" -> ChannelMethods.typing(call, result)
                "Channel#destroy" -> ChannelMethods.destroy(call, result)
                "Channel#getMessagesCount" -> ChannelMethods.getMessagesCount(call, result)
                "Channel#getUnreadMessagesCount" -> ChannelMethods.getUnreadMessagesCount(call, result)
                "Channel#getMembersCount" -> ChannelMethods.getMembersCount(call, result)
                "Channel#setAttributes" -> ChannelMethods.setAttributes(call, result)
                "Channel#getFriendlyName" -> ChannelMethods.getFriendlyName(call, result)
                "Channel#setFriendlyName" -> ChannelMethods.setFriendlyName(call, result)
                "Channel#getNotificationLevel" -> ChannelMethods.getNotificationLevel(call, result)
                "Channel#setNotificationLevel" -> ChannelMethods.setNotificationLevel(call, result)
                "Channel#getUniqueName" -> ChannelMethods.getUniqueName(call, result)
                "Channel#setUniqueName" -> ChannelMethods.setUniqueName(call, result)
    
                "Channels#getChannel" -> ChannelsMethods.getChannel(call, result)
                "Channels#getPublicChannelsList" -> ChannelsMethods.getPublicChannelsList(call, result)
                "Channels#getUserChannelsList" -> ChannelsMethods.getUserChannelsList(call, result)
    
                "Member#getUserDescriptor" -> MemberMethods.getUserDescriptor(call, result)
                "Member#getAndSubscribeUser" -> MemberMethods.getAndSubscribeUser(call, result)
                "Member#setAttributes" -> MemberMethods.setAttributes(call, result)
    
                "Members#getMembersList" -> MembersMethods.getMembersList(call, result)
                "Members#getMember" -> MembersMethods.getMember(call, result)
                "Members#addByIdentity" -> MembersMethods.addByIdentity(call, result)
                "Members#inviteByIdentity" -> MembersMethods.inviteByIdentity(call, result)
                "Members#removeByIdentity" -> MembersMethods.removeByIdentity(call, result)
    
                "Message#updateMessageBody" -> MessageMethods.updateMessageBody(call, result)
                "Message#setAttributes" -> MessageMethods.setAttributes(call, result)
                "Message#getMedia" -> MessageMethods.getMedia(call, result)
    
                "Messages#sendMessage" -> MessagesMethods.sendMessage(call, result)
                "Messages#removeMessage" -> MessagesMethods.removeMessage(call, result)
                "Messages#getMessagesBefore" -> MessagesMethods.getMessagesBefore(call, result)
                "Messages#getMessagesAfter" -> MessagesMethods.getMessagesAfter(call, result)
                "Messages#getLastMessages" -> MessagesMethods.getLastMessages(call, result)
                "Messages#getMessageByIndex" -> MessagesMethods.getMessageByIndex(call, result)
                "Messages#setLastReadMessageIndexWithResult" -> MessagesMethods.setLastReadMessageIndexWithResult(call, result)
                "Messages#advanceLastReadMessageIndexWithResult" -> MessagesMethods.advanceLastReadMessageIndexWithResult(call, result)
                "Messages#setAllMessagesReadWithResult" -> MessagesMethods.setAllMessagesReadWithResult(call, result)
                "Messages#setNoMessagesReadWithResult" -> MessagesMethods.setNoMessagesReadWithResult(call, result)
    
                else -> result.notImplemented()
            }
        }
    }

    private fun create(call: MethodCall, result: MethodChannel.Result) {
        Log.d("TwilioInfo", "TwilioConversationsPlugin.create => called")

        val token = call.argument<String>("token")
        val propertiesObj = call.argument<Map<String, Any>>("properties")
        if (token == null) {
            return result.error("ERROR", "Missing token", null)
        }
        if (propertiesObj == null) {
            return result.error("ERROR", "Missing properties", null)
        }

        try {
            if (TwilioConversationsPlugin.chatClient == null) {
                Log.d("TwilioInfo", "TwilioConversationsPlugin.create => making a fresh ChatClient")
            } else {
                Log.d("TwilioInfo", "TwilioConversationsPlugin.create => ChatClient is already set, overriding")
                TwilioConversationsPlugin.chatClient = null
                Log.d("TwilioInfo", "TwilioConversationsPlugin.create => ChatClient is set to null")
            }
                val propertiesBuilder = ConversationsClient.Properties.newBuilder()
                if (propertiesObj["region"] != null) {
                    Log.d("TwilioInfo", "TwilioConversationsPlugin.create => setting Properties.region to '${propertiesObj["region"]}'")
                    propertiesBuilder.setRegion(propertiesObj["region"] as String)
                }
    
                if (propertiesObj["deferCA"] != null) {
                    Log.d("TwilioInfo", "TwilioConversationsPlugin.create => setting Properties.setDeferCertificateTrustToPlatform to '${propertiesObj["deferCA"]}'")
                    propertiesBuilder.setDeferCertificateTrustToPlatform(propertiesObj["deferCA"] as Boolean)
                }
    
                TwilioConversationsPlugin.chatListener = ChatListener(propertiesBuilder.createProperties())
    
                ConversationsClient.create(applicationContext, token, TwilioConversationsPlugin.chatListener.properties, object : CallbackListener<ConversationsClient> {
                    override fun onSuccess(chatClient: ConversationsClient) {
                        if (TwilioConversationsPlugin.chatClient == null) {
                            Log.d("Twilio init success", "TwilioConversationsPlugin.create => ChatClient.create onSuccess: myIdentity is '${chatClient.myIdentity}'")
                            try {
                                TwilioConversationsPlugin.chatClient = chatClient
                                val chatClientMap = Mapper.chatClientToMap(chatClient)
                                result.success(chatClientMap)
                            } catch (e: Exception) {
                                Log.d("TwilioInfo", "TwilioConversationsPlugin.create => ChatClient.create onSuccess: failed to give result")
                                Log.d("Twilio error", "TwilioConversationsPlugin.create => ChatClient.create onSuccess: failed to give result: $e : $chatClient : ${Mapper.chatClientToMap(chatClient)}")
                                result.error("$e", "Failed to map chatClient", null)
                            }
                        }
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                            try {
                                with(TwilioConversationsPlugin) { debug("TwilioConversationsPlugin.create => ChatClient.create onError: $errorInfo") }
                                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                            } catch (e1: Exception) {
                                Log.d("TwilioInfo", "TwilioConversationsPlugin.create => ChatClient.create error: failed to send result of onError: $e1")
                            }
                    }
                })
        } catch (e: Exception) {
            result.error("ERROR", e.toString(), e)
        }
    }

    private fun debug(call: MethodCall, result: MethodChannel.Result) {
        val enableNative = call.argument<Boolean>("native")
        val enableSdk = call.argument<Boolean>("sdk")

        if (enableSdk != null && enableSdk) {
            ConversationsClient.setLogLevel(ConversationsClient.LogLevel.DEBUG)
        }

        if (enableNative != null) {
            TwilioConversationsPlugin.nativeDebug = enableNative
            result.success(enableNative)
        } else {
            result.error("MISSING_PARAMS", "Missing 'native' parameter", null)
        }
    }
}
