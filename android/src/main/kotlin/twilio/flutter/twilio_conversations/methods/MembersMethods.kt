package twilio.flutter.twilio_conversations.methods

import com.twilio.conversations.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import twilio.flutter.twilio_conversations.Mapper
import twilio.flutter.twilio_conversations.TwilioConversationsPlugin
import com.twilio.util.ErrorInfo
import android.util.Log

object MembersMethods {
    fun getChannel(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MembersMethods.getChannel => onSuccess")
                result.success(Mapper.channelToMap(channel))
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MembersMethods.getChannel => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getMembersList(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MembersMethods.getMembersList (Channels.getChannel) => onSuccess")
                val membersListMap = Mapper.membersListToMap(channel.participantsList)
                result.success(membersListMap)
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MembersMethods.getMembersList (Channels.getChannel) onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun getMember(call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MembersMethods.getMember (Channels.getChannel) => onSuccess")
                val memberMap = Mapper.memberToMap(channel.participantsList.findLast { it.identity == identity })
                result.success(memberMap)
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MembersMethods.getMember (Channels.getChannel) onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun addByIdentity(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MembersMethods.addByIdentity (Channels.getChannel) => onSuccess")
                channel.addParticipantByIdentity(identity, Attributes(), object : StatusListener {
                    override fun onSuccess() {
                        Log.d("TwilioInfo", "MembersMethods.addByIdentity (Members.addByIdentity) => onSuccess")
                        result.success(true)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MembersMethods.addByIdentity (Members.addByIdentity) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MembersMethods.addByIdentity (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun inviteByIdentity(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MembersMethods.inviteByIdentity (Channels.getChannel) => onSuccess")
                channel.addParticipantByIdentity(identity, Attributes(), object : StatusListener {
                    override fun onSuccess() {
                        Log.d("TwilioInfo", "MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onSuccess")
                        result.success(true)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MembersMethods.inviteByIdentity (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }

    fun removeByIdentity(call: MethodCall, result: MethodChannel.Result) {
        val identity = call.argument<String>("identity")
                ?: return result.error("ERROR", "Missing 'identity'", null)
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MembersMethods.removeByIdentity (Channels.getChannel) => onSuccess")

                channel.removeParticipantByIdentity(identity, object : StatusListener {
                    override fun onSuccess() {
                        Log.d("TwilioInfo", "MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onSuccess")
                        result.success(true)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        Log.d("TwilioInfo", "MembersMethods.inviteByIdentity (Members.inviteByIdentity) => onError: $errorInfo")
                        result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
                    }
                })

            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MembersMethods.removeByIdentity (Channels.getChannel) => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })
    }
}
