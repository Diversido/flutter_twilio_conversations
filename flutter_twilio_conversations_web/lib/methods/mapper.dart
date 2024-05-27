import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
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
    // print('Martin! user ${users}');
    return {
      "channels": channelsToMap(pluginInstance, channels),
      "myIdentity": "", // TODO
      "connectionState": connectionStateToString(chatClient.connectionState),
      // "users": usersToMap(users), //TODO Martin
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
      'attributes': attributesToMap(channel.attributes),
      'messages': messagesToMap(messages),
      'status': channel.status.toString(),
      'synchronizationStatus': channel.synchronizationStatus
          .toString(), // channel.conversationStatus.ChannelStatus
      'dateCreated': dateToString(channel.dateCreatedAsDate),
      'createdBy': channel.createdBy,
      'dateUpdated': dateToString(channel.dateUpdated),
      'lastMessageDate':
          dateToString(channel.lastMessageDate), //TODO lastMessage.date?
      'lastMessageIndex': channel.lastMessageIndex, //TODO lastMessage.index?
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
    //TODO
    print('JSONValue is $attributes');
    return {};
    // late String type;
    // late String data;

    // switch(attributes.type) {
    //   case AttributesType.OBJECT:
    //     type = "object";
    //     data = "${attributes.jsonObject}";
    //     break;
    //   case AttributesType.ARRAY:
    //     type = "array";
    //     data = "${attributes.jsonArray}";
    //     break;
    //   case AttributesType.STRING:
    //     type = "string";
    //     data = attributes.string!;
    //     break;
    //   case AttributesType.NUMBER:
    //     type = "number";
    //     data = attributes.number!.toString();
    //     break;
    //   case AttributesType.BOOLEAN:
    //     type = "boolean";
    //     data = attributes.boolean!.toString();
    //     break;
    //   case AttributesType.NULL:
    //     type = "null";
    //     data = "null";
    //     break;
    // }
  }

  static Map<String, dynamic>? messagesToMap(
      List<TwilioConversationsMessage>? messages) {
    if (messages == null) return null;

    var index = -1;
    for (TwilioConversationsMessage message in messages) {
      if (message.conversation.lastReadMessageIndex > index) {
        index = message.conversation.lastReadMessageIndex;
      }
    }
    return {"lastReadMessageIndex": index};
  }

  static String? dateToString(DateTime? date) {
    //TODO
    return '2024-05-22 12:00:00';
    print('p: dateToString $date');
    if (date == null) return null;
    final dateFormat =
        DateFormat('yyyy-MM-dd hh:mm:ss'); //TODO HH vs hh and fix this method
    return dateFormat.format(date);
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
