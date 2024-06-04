import 'dart:async';
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/media.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/member.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioClient;
import 'package:flutter_twilio_conversations_web/interop/classes/twilio_json.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/user.dart';
import 'package:flutter_twilio_conversations_web/listeners/channel_listener.dart';
import 'package:intl/intl.dart';

class Mapper {
  static Future<Map<String, dynamic>?> chatClientToMap(
    TwilioConversationsPlugin pluginInstance,
    TwilioClient.TwilioConversationsClient chatClient,
    List<TwilioConversationsChannel>? channels,
  ) async {
    // final users = await promiseToFuture(chatClient.getSubscribedUsers()); // TODO move this outside of Mapper
    final channelsMapped = await channelsToMap(pluginInstance, channels);
    return {
      "channels": channelsMapped,
      "myIdentity": "", // TODO
      "connectionState": connectionStateToString(chatClient.connectionState),
      // "users": usersToMap(users), //TODO
      "isReachabilityEnabled": true, // TODO
    };
  }

//MappedListIterable<TwilioConversationsChannel, Future<Map<String, dynamic>?>> (())
  static String connectionStateToString(ConnectionState state) {
    return state.toString().split('.').last;
  }

  static Future<Map<String, dynamic>> channelsToMap(
    TwilioConversationsPlugin pluginInstance,
    List<TwilioConversationsChannel>? channels,
  ) async {
    if (channels == null) return {};
    final subscribedChannelsMap = await Future.wait(
      channels.map((channel) => channelToMap(pluginInstance, channel)).toList(),
    );

    return {"subscribedChannels": subscribedChannelsMap};
  }

  static Future<Map<String, dynamic>?> channelToMap(
    TwilioConversationsPlugin pluginInstance,
    TwilioConversationsChannel? channel,
  ) async {
    if (channel == null) {
      return null;
    }

    //TODO Implement the same as Mapper.kt
    // Setting flutter event listener for the given channel if one does not yet exist.

    /* _chatStream = FlutterTwilioConversationsPlatform.instance
            .chatClientStream()!
            .listen((_parseEvents));
    */
    if (!pluginInstance.channelChannels.containsKey(channel.sid)) {
      final channelStreamController =
          StreamController<Map<String, dynamic>>.broadcast();

      pluginInstance.channelChannels[channel.sid] = ChannelEventListener(
        channel,
        channelStreamController,
      );
      //  EventChannel('flutter_twilio_conversations/${channel.sid}') as ChannelEventListener;

      pluginInstance.channelChannels[channel.sid]!.addListeners();

      pluginInstance.channelListeners[channel.sid] = channelStreamController;

      /* pluginInstance.channelChannels[channel.sid]?.setStreamHandler(
        StreamHandler(
          onListen: (arguments, EventSink events) {
            print(
                "TwilioInfo: Mapper.channelToMap => EventChannel for Channel(${channel.sid}) attached");
            pluginInstance.channelListeners[channel.sid] =
                ChannelListener(pluginInstance, events);
            channel.addListener(pluginInstance.channelListeners[channel.sid]);
          },
          onCancel: (arguments) {
            print(
                "TwilioInfo: Mapper.channelToMap => EventChannel for Channel(${channel.sid}) detached");
            channel
                .removeListener(pluginInstance.channelListeners[channel.sid]);
            pluginInstance.channelListeners.remove(channel.sid);
            pluginInstance.channelChannels.remove(channel.sid);
          },
        ),
      ); */
    }

    try {
      final messages =
          await promiseToFuture<JSPaginator<TwilioConversationsMessage>>(
              channel.getMessages());
      final channelMap = {
        'sid': channel.sid,
        'type': 'UNKNOWN',
        'messages': messagesToMap(messages.items),
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
    } catch (e) {
      final channelMap = {
        'sid': channel.sid,
        'type': 'UNKNOWN',
        'messages': messagesToMap(<TwilioConversationsMessage>[]),
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

  // static Attributes? mapToAttributes( Map<String, dynamic>? map) {
  //       if (map == null) return null;
  //       val attrObject = mapToJSONObject(map);
  //       if (attrObject != null) return Attributes(attrObject); else return null;
  //   }

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
    if (messages == null) return null;

    var index = -1;
    for (TwilioConversationsMessage message in messages) {
      if (message.conversation.lastReadMessageIndex! > index) {
        index = message.conversation.lastReadMessageIndex!;
      }
    }
    return {"lastReadMessageIndex": index};
  }

  static String? dateToString(dynamic date) {
    if (date == null) return null;
    final dateTime = DateTime.fromMicrosecondsSinceEpoch(date.getTime() * 1000);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return dateFormat.format(dateTime);
  }

  static Future<Map<String, dynamic>> messageToMap(
      TwilioConversationsMessage message) async {
    try {
      final member = await promiseToFuture<TwilioConversationsMember>(
          message.getParticipant());
      return messageMapped(message, member);
    } catch (e) {
      return messageMapped(message, null);
    }
  }

  static Map<String, dynamic> messageMapped(
      TwilioConversationsMessage message, TwilioConversationsMember? member) {
    final messageMapped = {
      "sid": message.sid,
      "author": message.author,
      "dateCreated": dateToString(message.dateCreated),
      "messageBody": message.body,
      "channelSid": message.conversation.sid,
      "memberSid": message.participantSid,
      "member": memberToMap(member),
      "messageIndex": message.index,
      "hasMedia":
          false, //message.getAttachedMedia().isNotEmpty(), //TODO Implement
      // "media": mediaToMap(message), //TODO Implement
      "attributes": attributesToMap(message.attributes),
    };

    return messageMapped;
  }

  static Map<String, dynamic>? memberToMap(TwilioConversationsMember? member) {
    if (member == null) return null;
    return {
      "sid": member.sid,
      "lastReadMessageIndex": member.lastReadMessageIndex,
      "lastReadTimestamp": dateToString(member.lastReadTimestamp),
      "channelSid": member.conversation.sid,
      "identity": member.identity,
      "type": member.type,
      "attributes": attributesToMap(member.attributes)
    };
  }

  static Map<String, dynamic>? errorInfoToMap(ErrorInfo? e) {
    //TODO user introp for error info here?
    if (e == null) return null;
    return {"code": e.code, "message": e.message, "status": e.status};
  }
}
