import 'dart:async';
import 'dart:convert';
import 'dart:js_util' as js_util;
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/member.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioClient;
import 'package:flutter_twilio_conversations_web/listeners/channel_listener.dart';
import 'package:flutter_twilio_conversations_web/logging.dart';
import 'package:flutter_twilio_conversations_web/types/connection_state.dart';
import 'package:flutter_twilio_conversations_web/types/error_info.dart';
import 'package:intl/intl.dart';

final emptyUser = {
  "friendlyName": "",
  "attributes": {},
  "identity": "",
  "isOnline": "",
  "isNotifiable": "",
  "isSubscribed": ""
};

class Mapper {
  static Future<Map<String, dynamic>?> chatClientToMap(
    TwilioConversationsPlugin pluginInstance,
    TwilioClient.TwilioConversationsClient chatClient,
    List<TwilioConversationsChannel>? channels,
  ) async {
    final channelsMapped = await channelsToMap(pluginInstance, channels);
    final usersMapped = await usersToMap(pluginInstance, chatClient);
    return {
      "channels": channelsMapped,
      "myIdentity": chatClient.user.identity,
      "connectionState": connectionStateToString(chatClient.connectionState),
      "users": usersMapped,
      "isReachabilityEnabled": chatClient.reachabilityEnabled,
    };
  }

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

    if (!pluginInstance.channelChannels.containsKey(channel.sid)) {
      final channelStreamController =
          StreamController<Map<String, dynamic>>.broadcast();

      pluginInstance.channelChannels[channel.sid] = ChannelEventListener(
        pluginInstance,
        channel,
        channelStreamController,
      );

      pluginInstance.channelChannels[channel.sid]!.addListeners();
      pluginInstance.channelListeners[channel.sid] = channelStreamController;
    }

    try {
      final messages = await js_util
          .promiseToFuture<JSPaginator<TwilioConversationsMessage>>(
        channel.getMessages(50, 0, "forward"),
      );
      return channelMapped(pluginInstance, channel, messages);
    } catch (e) {
      return channelMapped(pluginInstance, channel, null);
    }
  }

  static channelMapped(
      TwilioConversationsPlugin pluginInstance,
      TwilioConversationsChannel channel,
      JSPaginator<TwilioConversationsMessage>? messages) {
    final channelMap = {
      'sid': channel.sid,
      'type': 'UNKNOWN',
      'messages': messagesToMap(messages?.items),
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

  static Future<Map<String, dynamic>?> usersToMap(
    TwilioConversationsPlugin pluginInstance,
    TwilioClient.TwilioConversationsClient chatClient,
  ) async {
    List<dynamic>? users = [];
    try {
      users = await js_util.promiseToFuture<List<dynamic>?>(
        chatClient.getSubscribedUsers(),
      );
    } catch (e) {
      Logging.debug('error getting users: $e');
    }

    if (users!.isEmpty) return {};

    var myUser = {
      "friendlyName": "",
      "attributes": {},
      "identity": chatClient.user.identity,
      "isOnline": "",
      "isNotifiable": "",
      "isSubscribed": ""
    };

    late final subscribedUsersMap;
    try {
      subscribedUsersMap = await Future.wait(
        users
            .map((user) => userToMap(
                  user,
                  chatClient,
                ))
            .toList(),
      );
    } catch (e) {
      Logging.debug("error in userToMap: $e");
    }
    try {
      return {
        "subscribedUsers": subscribedUsersMap ?? {},
        "myUser": await userToMap(myUser, chatClient)
      };
    } catch (e) {
      Logging.debug("error mapping myUser: $e");
      return {"subscribedUsers": subscribedUsersMap ?? {}, "myUser": emptyUser};
    }
  }

  static Future<Map<String, dynamic>> userToMap(
    dynamic user,
    TwilioClient.TwilioConversationsClient chatClient,
  ) async {
    try {
      final userProperties = await js_util.promiseToFuture(
        chatClient.getUser(user.identity),
      );

      return {
        "friendlyName": userProperties.friendlyName,
        "attributes": attributesToMap(userProperties.attributes),
        "identity": userProperties.identity,
        "isOnline": userProperties.isOnline,
        "isNotifiable": userProperties.isNotifiable,
        "isSubscribed": userProperties.isSubscribed
      };
    } catch (e) {
      return emptyUser;
    }
  }

  static Map<String, dynamic>? attributesToMap(dynamic attributes) {
    try {
      if (attributes == null) {
        return {"type": "NULL", "data": null};
      }
      final map = jsToMap(attributes);
      return {"type": "OBJECT", "data": json.encode(map)};
    } catch (e) {
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
    try {
      if (date == null) return null;

      final time = js_util.callMethod(date, 'getTime', []);
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time).toUtc();
      final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      return dateFormat.format(dateTime);
    } catch (e) {
      Logging.debug("error mapping dateToString: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> messageToMap(
      TwilioConversationsMessage message) async {
    try {
      final member = await js_util.promiseToFuture<TwilioConversationsMember>(
        message.getParticipant(),
      );
      return messageMapped(message, member);
    } catch (e) {
      Logging.debug("error mapping messageToMap: $e");
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
      "hasMedia": message.attachedMedia.isNotEmpty,
      "media": mediaToMap(message),
      "attributes": attributesToMap(message.attributes),
    };

    return messageMapped;
  }

  static Map<String, dynamic>? mediaToMap(TwilioConversationsMessage message) {
    if (message.attachedMedia.isEmpty) {
      return null;
    }

    return {
      "sid": message.attachedMedia[0].sid,
      "fileName": message.attachedMedia[0].filename,
      "type": message.attachedMedia[0].contentType,
      "size": message.attachedMedia[0].size,
      "channelSid": message.conversation.sid,
      "messageIndex": message.index
    };
  }

  static Map<String, dynamic>? memberToMap(TwilioConversationsMember? member) {
    if (member == null) return null;
    return {
      "sid": member.sid,
      "lastReadMessageIndex": member.lastReadMessageIndex,
      "lastReadTimestamp": dateToString(member.lastReadTimestamp) ?? "",
      "channelSid": member.conversation.sid,
      "identity": member.identity,
      "type": memberTypeToString(member.type),
      "attributes": attributesToMap(member.attributes)
    };
  }

  static memberTypeToString(String type) {
    switch (type) {
      case "chat":
        return "CHAT";
      case "sms":
        return "SMS";
      case "unset":
        return "UNSET";
      case "whatsapp":
        return "WHATSAPP";
      default:
        return "OTHER";
    }
  }

  static Map<String, dynamic>? errorInfoToMap(ErrorInfo? e) {
    if (e == null) return null;
    return {"code": e.code, "message": e.message, "status": e.status};
  }
}
