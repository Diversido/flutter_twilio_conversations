import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioClient;
import 'package:flutter_twilio_conversations_web/interop/classes/twilio_json.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/user.dart';
import 'package:intl/intl.dart';

class Mapper {
  static Map<String, dynamic>? chatClientToMap(
    TwilioConversationsPlugin pluginInstance,
    TwilioClient.TwilioConversationsClient chatClient,
    List<TwilioConversationsChannel>? channels,
  ) {
    // final users = await promiseToFuture(chatClient.getSubscribedUsers()); // TODO move this outside of Mapper

    return {
      "channels": channelsToMap(pluginInstance, channels),
      "myIdentity": "", // TODO
      "connectionState": connectionStateToString(chatClient.connectionState),
      // "users": usersToMap(users), //TODO
      "isReachabilityEnabled": true, // TODO
    };
  }

  static String connectionStateToString(ConnectionState state) {
    return state.toString().split('.').last;
  }

  static Map<String, dynamic>? channelsToMap(
      TwilioConversationsPlugin pluginInstance,
      List<TwilioConversationsChannel>? channels) {
    if (channels == null) return {};
    var subscribedChannelsMap =
        channels.map((channel) => channelToMap(pluginInstance, channel));

    return {"subscribedChannels": subscribedChannelsMap};
  }

  static Map<String, dynamic>? channelToMap(
    TwilioConversationsPlugin pluginInstance,
    TwilioConversationsChannel? channel,
  ) {
    if (channel == null) {
      return null;
    }

    //TODO Implement the same as Mapper.kt
    // Setting flutter event listener for the given channel if one does not yet exist.

    /* _chatStream = FlutterTwilioConversationsPlatform.instance
            .chatClientStream()!
            .listen((_parseEvents));
    */

    // if (!pluginInstance.channelChannels.containsKey(channel.sid)) {
    //     pluginInstance.channelChannels[channel.sid] = EventChannel("flutter_twilio_conversations/${channel.sid}");
    //     pluginInstance.channelChannels[channel.sid]?.

    // setStreamHandler(object : EventChannel.StreamHandler {
    //     override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    //         Log.d("TwilioInfo", "Mapper.channelToMap => EventChannel for Channel(${channel.sid}) attached")
    //         pluginInstance.channelListeners[channel.sid] = ChannelListener(pluginInstance, events)
    //         channel.addListener(pluginInstance.channelListeners[channel.sid])
    //     }

    //     override fun onCancel(arguments: Any?) {
    //         Log.d("TwilioInfo", "Mapper.channelToMap => EventChannel for Channel(${channel.sid}) detached")
    //         channel.removeListener(pluginInstance.channelListeners[channel.sid])
    //         pluginInstance.channelListeners.remove(channel.sid)
    //         pluginInstance.channelChannels.remove(channel.sid)
    //     }
    // })
    //  }

    final messages = <TwilioConversationsMessage>[];

    final channelMap = {
      'sid': channel.sid,
      'type': 'UNKNOWN',
      'messages': messagesToMap(messages),
      'attributes': attributesToMap(channel.attributes),
      'status': channel.status,
      'synchronizationStatus': 'ALL',
      'dateCreated': dateToString(channel.dateCreated),
      'createdBy': channel.createdBy,
      'dateUpdated': dateToString(channel.dateUpdated),
      'lastMessageDate': dateToString(channel.lastMessage?.dateCreated),
      'lastMessageIndex': channel.lastMessage?.index,
    };

    return channelMap;
  }

  static Map<String, dynamic>? usersToMap(
      List<TwilioConversationsUser>? users) {
    //TODO
    if (users == null) return {};
    var subscribedUsersMap = users!.map((user) => userToMap(user));
    var myUser = null;
    // try {
    //     if (TwilioConversationsPlugin.chatClient?.myUser != null) {
    //         myUser = TwilioConversationsPlugin.chatClient?.myUser
    //     }
    // } catch (e) {
    //    print("myUser is null ${e.toString()}");
    // }

    return {"subscribedUsers": subscribedUsersMap, "myUser": userToMap(myUser)};
  }

  static Map<String, dynamic>? userToMap(TwilioConversationsUser user) {
    // TODO
    if (user != null) {
      return {
        "friendlyName": user.friendlyName,
        // "attributes" : attributes:Map(user.attributes),
        "identity": user.identity,
        // "isOnline" : user.isOnline,
        // "isNotifiable" : user.isNotifiable,
        // "isSubscribed" : user.isSubscribed
      };
    } else {
      return {
        "friendlyName": "",
        "attributes": "",
        "identity": "",
        "isOnline": "",
        "isNotifiable": "",
        "isSubscribed": "",
      };
    }
  }

  static Map<String, dynamic>? attributesToMap(JSONValue? attributes) {
    if (attributes == null) {
      return {"type": "NULL", "data": null};
    } else if (attributes.number != null) {
      return {"type": "NUMBER", "data": attributes.number?.toString()};
    } else if (attributes.string != null) {
      return {"type": "STRING", "data": attributes.string};
    } else if (attributes.JSONArray != null) {
      return {"type": "ARRAY", "data": attributes.JSONArray};
    } else if (attributes.JSONObject != null) {
      return {"type": "OBJECT", "data": attributes.JSONObject};
    } else {
      return {"type": "NULL", "data": null};
    }
  }

  static Map<String, dynamic>? messagesToMap(
      List<TwilioConversationsMessage>? messages) {
    return null;
    if (messages == null) return null;

    // var index = -1;
    // for (TwilioConversationsMessage message in messages) {
    //   if (message.conversation.lastReadMessageIndex > index) {
    //     index = message.conversation.lastReadMessageIndex;
    //   }
    // }
    return {"lastReadMessageIndex": '0'};
  }

  static String? dateToString(dynamic date) {
    if (date == null) return null;
    final dateTime = DateTime.fromMicrosecondsSinceEpoch(date.getTime() * 1000);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return dateFormat.format(dateTime);
  }

  static Map<String, dynamic> messageToMap(TwilioConversationsMessage message) {
    //TODO
    return {
      "sid": message.sid,
      "author": message.author,
      "dateCreated": message.dateCreated,
      "messageBody": message.body,
      "channelSid": message.channelSid,
      "memberSid": message.participantSid,
      // "member": memberToMap(message.participant), //TODO implement memberToMap
      "messageIndex": message.index,
      // "hasMedia": message.getAttachedMedia().isNotEmpty(), //TODO Implement
      // "media": mediaToMap(message), //TODO Implement
      "attributes": attributesToMap(message.attributes),
    };
  }

  static Map<String, dynamic>? errorInfoToMap(ErrorInfo? e) {
    //TODO user introp for error info here?
    if (e == null) return null;
    return {"code": e.code, "message": e.message, "status": e.status};
  }
}
