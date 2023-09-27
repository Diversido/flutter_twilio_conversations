package twilio.flutter.twilio_conversations

import android.util.Log
import com.twilio.conversations.*
import com.twilio.util.ErrorInfo
import io.flutter.plugin.common.EventChannel
import java.text.SimpleDateFormat
import org.json.JSONArray
import org.json.JSONObject
import twilio.flutter.twilio_conversations.listeners.ChannelListener
import java.util.*

object Mapper {
    fun jsonObjectToMap(jsonObject: JSONObject): Map<String, Any?> {
        val result = mutableMapOf<String, Any?>()
        jsonObject.keys().forEach {
            if (jsonObject[it] == null || JSONObject.NULL == jsonObject[it]) {
                result[it] = null
            } else if (jsonObject[it] is JSONObject) {
                result[it] = jsonObjectToMap(jsonObject[it] as JSONObject)
            } else if (jsonObject[it] is JSONArray) {
                result[it] = jsonArrayToList(jsonObject[it] as JSONArray)
            } else {
                result[it] = jsonObject[it]
            }
        }
        return result
    }

    fun jsonArrayToList(jsonArray: JSONArray): List<Any?> {
        val result = mutableListOf<Any?>()
        for (i in 0 until jsonArray.length()) {
            if (jsonArray[i] == null || JSONObject.NULL == jsonArray[i]) {
                result[i] = null
            } else if (jsonArray[i] is JSONObject) {
                result[i] = jsonObjectToMap(jsonArray[i] as JSONObject)
            } else if (jsonArray[i] is JSONArray) {
                result[i] = jsonArrayToList(jsonArray[i] as JSONArray)
            } else {
                result[i] = jsonArray[i]
            }
        }
        return result
    }

    fun mapToJSONObject(map: Map<String, Any>?): JSONObject? {
        if (map == null) {
            return null
        }
        val result = JSONObject()
        map.keys.forEach {
            if (map[it] == null) {
                result.put(it, null)
            } else if (map[it] is Map<*, *>) {
                result.put(it, mapToJSONObject(map[it] as Map<String, Any>))
            } else if (map[it] is List<*>) {
                result.put(it, listToJSONArray(map[it] as List<Any>))
            } else {
                result.put(it, map[it])
            }
        }
        return result
    }

    fun mapToAttributes(map: Map<String, Any>?): Attributes? {
        if (map == null) return null
        val attrObject = mapToJSONObject(map)
        if (attrObject != null) return Attributes(attrObject) else return null
    }

    fun listToJSONArray(list: List<Any>): JSONArray {
        val result = JSONArray()
        list.forEach {
            if (it is Map<*, *>) {
                result.put(mapToJSONObject(it as Map<String, Any>))
            } else if (it is List<*>) {
                result.put(listToJSONArray(it as List<Any>))
            } else {
                result.put(it)
            }
        }
        return result
    }

    fun chatClientToMap(chatClient: ConversationsClient): Map<String, Any> {
        return mapOf(
                "channels" to channelsToMap(chatClient.myConversations),
                "myIdentity" to chatClient.myIdentity,
                "connectionState" to chatClient.connectionState.toString(),
                "users" to usersToMap(chatClient.subscribedUsers),
                "isReachabilityEnabled" to chatClient.isReachabilityEnabled
        )
    }

    fun attributesToMap(attributes: Attributes): Map<String, Any?> {
        return when {
            attributes.boolean != null -> mapOf(
                "type" to "boolean",
                "data" to attributes.boolean!!,
            )
            attributes.number != null -> mapOf(
                "type" to "number",
                "data" to attributes.number!!,
            )
            attributes.string != null -> mapOf(
                "type" to "string",
                "data" to attributes.string!!,
            )
            attributes.jsonArray != null -> mapOf(
                "type" to "array",
                "data" to "${attributes.jsonArray}",
            )
            attributes.jsonObject != null -> mapOf(
                "type" to "object",
                "data" to "${attributes.jsonObject}",
            )
            else -> mapOf(
                "type" to "null",
                "data" to null,
            )
        }
    }

    private fun channelsToMap(channels: List<Conversation>): Map<String, Any> {
        val subscribedChannelsMap = channels.map { channelToMap(it) }
        return mapOf(
                "subscribedChannels" to subscribedChannelsMap
        )
    }

    fun channelToMap(channel: Conversation?): Map<String, Any?>? {
        if (channel == null) {
            return null
        }

        // Setting flutter event listener for the given channel if one does not yet exist.
        if (!TwilioConversationsPlugin.channelChannels.containsKey(channel.sid)) {
            TwilioConversationsPlugin.channelChannels[channel.sid] = EventChannel(TwilioConversationsPlugin.messenger, "flutter_twilio_conversations/${channel.sid}")
            TwilioConversationsPlugin.channelChannels[channel.sid]?.setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    Log.d("TwilioInfo", "Mapper.channelToMap => EventChannel for Channel(${channel.sid}) attached")
                    TwilioConversationsPlugin.channelListeners[channel.sid] = ChannelListener(events)
                    channel.addListener(TwilioConversationsPlugin.channelListeners[channel.sid])
                }

                override fun onCancel(arguments: Any?) {
                    Log.d("TwilioInfo", "Mapper.channelToMap => EventChannel for Channel(${channel.sid}) detached")
                    channel.removeListener(TwilioConversationsPlugin.channelListeners[channel.sid])
                    TwilioConversationsPlugin.channelListeners.remove(channel.sid)
                    TwilioConversationsPlugin.channelChannels.remove(channel.sid)
                }
            })
        }

        val messages = mutableListOf<Message>()

        return mapOf(
                "sid" to channel.sid,
                "type" to "UNKNOWN",
                "messages" to messagesToMap(messages),
                "attributes" to attributesToMap(channel.attributes),
                "status" to channel.status.toString(),
                "synchronizationStatus" to channel.synchronizationStatus.toString(),
                "dateCreated" to dateToString(channel.dateCreatedAsDate),
                "createdBy" to channel.createdBy,
                "dateUpdated" to dateToString(channel.dateUpdatedAsDate),
                "lastMessageDate" to dateToString(channel.lastMessageDate),
                "lastMessageIndex" to channel.lastMessageIndex
        )
    }

    fun usersToMap(users: List<User>): Map<String, Any> {
        val subscribedUsersMap = users.map { userToMap(it) }
        var myUser: User? = null
        try {
            if (TwilioConversationsPlugin.chatClient?.myUser != null) {
                myUser = TwilioConversationsPlugin.chatClient?.myUser
            }
        } catch (e: Exception) {
            Log.d("TwilioInfo", "TwilioConversationsPlugin.chatClient?.myUser is null")
        }

        return mapOf(
                "subscribedUsers" to subscribedUsersMap,
                "myUser" to userToMap(myUser)
        )
    }

    fun userToMap(user: User?): Map<String, Any> {
        if (user != null) {
            return mapOf(
                    "friendlyName" to user.friendlyName,
                    "attributes" to attributesToMap(user.attributes),
                    "identity" to user.identity,
                    "isOnline" to user.isOnline,
                    "isNotifiable" to user.isNotifiable,
                    "isSubscribed" to user.isSubscribed
            )
        } else {
            return mapOf(
                    "friendlyName" to "",
                    "attributes" to "",
                    "identity" to "",
                    "isOnline" to "",
                    "isNotifiable" to "",
                    "isSubscribed" to ""
            )
        }
    }

    private fun messagesToMap(messages: List<Message>?): Map<String, Any>? {
        if (messages == null) return null
        var index = -1L
        for (message in messages) {
            if (message.conversation.lastReadMessageIndex > index) {
                index = message.conversation.lastReadMessageIndex
            }
        }
        return mapOf(
                "lastReadMessageIndex" to index
        )
    }

    fun messageToMap(message: Message): Map<String, Any?> {
        return mapOf(
                "sid" to message.sid,
                "author" to message.author,
                "dateCreated" to message.dateCreated,
                "messageBody" to message.getBody(),
                "channelSid" to message.conversationSid,
                "memberSid" to message.participantSid,
                "member" to memberToMap(message.participant),
                "messageIndex" to message.messageIndex,
                "hasMedia" to message.getAttachedMedia().isNotEmpty(),
                "media" to mediaToMap(message),
                "attributes" to attributesToMap(message.attributes)
        )
    }

    private fun mediaToMap(message: Message): Map<String, Any?>? {
        if (message.getAttachedMedia().isEmpty()) return null
        return mapOf<String, Any?>(
                "sid" to message.getAttachedMedia()[0].sid,
                "fileName" to message.getAttachedMedia()[0].filename,
                "type" to message.getAttachedMedia()[0].contentType,
                "size" to message.getAttachedMedia()[0].size,
                "channelSid" to message.conversationSid,
                "messageIndex" to message.messageIndex
        )
    }

    fun membersListToMap(members: List<Participant>): Map<String, List<Map<String, Any?>?>> {
        val membersListMap = members.map { memberToMap(it) }
        return mapOf(
            "membersList" to membersListMap
        )
    }

    fun memberToMap(member: Participant?): Map<String, Any?>? {
        if (member == null) return null
        return mapOf(
                "sid" to member.sid,
                "lastReadMessageIndex" to member.lastReadMessageIndex,
                "lastReadTimestamp" to member.lastReadTimestamp,
                "channelSid" to member.conversation.sid,
                "identity" to member.identity,
                "type" to member.type.toString(),
                "attributes" to attributesToMap(member.attributes)
        )
    }

    fun userDescriptorToMap(userDescriptor: User): Map<String, Any> {
        return mapOf(
                "friendlyName" to userDescriptor.friendlyName,
                "attributes" to attributesToMap(userDescriptor.attributes),
                "identity" to userDescriptor.identity,
                "isOnline" to userDescriptor.isOnline,
                "isNotifiable" to userDescriptor.isNotifiable
        )
    }

    fun channelDescriptorToMap(channelDescriptor: Conversation): Map<String, Any?> {
        return mapOf(
                "sid" to channelDescriptor.sid,
                "friendlyName" to channelDescriptor.friendlyName,
                "attributes" to attributesToMap(channelDescriptor.attributes),
                "uniqueName" to channelDescriptor.uniqueName,
                "dateUpdated" to dateToString(channelDescriptor.dateUpdatedAsDate),
                "dateCreated" to dateToString(channelDescriptor.dateCreatedAsDate),
                "createdBy" to channelDescriptor.createdBy,
                "membersCount" to channelDescriptor.participantsList.size,
                "messagesCount" to channelDescriptor.lastMessageIndex,
                "unreadMessagesCount" to channelDescriptor.lastMessageIndex-channelDescriptor.lastReadMessageIndex,
                "status" to channelDescriptor.status.toString()
        )
    }

    fun errorInfoToMap(e: ErrorInfo?): Map<String, Any?>? {
        if (e == null)
            return null
        return mapOf(
                "code" to e.code,
                "message" to e.message,
                "status" to e.status
        )
    }

    private fun dateToString(date: Date?): String? {
        if (date == null) return null
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US)
        return dateFormat.format(date)
    }
}
