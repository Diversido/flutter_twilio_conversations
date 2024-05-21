import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioClient;
import 'package:flutter_twilio_conversations_web/interop/classes/twilio_json.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/user.dart';
import 'package:intl/intl.dart';

class Mapper {
  static Map<String, dynamic>? chatClientToMap(
      TwilioClient.TwilioConversationsClient chatClient) {
    return {
      "channels": channelsToMap(chatClient.channels),
      "myIdentity": "chatClient.user.identity",
      "connectionState": chatClient.connectionState.toString(),
      "users": usersToMap(chatClient.users),
      "isReachabilityEnabled": chatClient.isReachabilityEnabled,
    };
  }

  static Map<String, dynamic>? channelsToMap(
      List<TwilioConversationsChannel>? channels) {
    if (channels == null) return {};
    var subscribedChannelsMap =
        channels.map((channel) => channelToMap(channel));

    return {"subscribedChannels": subscribedChannelsMap};
  }

  static Map<String, dynamic>? channelToMap(
      TwilioConversationsChannel? channel) {
    if (channel == null) {
      return null;
    }

    //TODO Implement the same as Mapper.kt
    // For channel stream

    final messages = <TwilioConversationsMessage>[];

    print('p: ${channel.synchronizationStatus.toString()}');
    return {
      'sid': channel.sid,
      'type': 'UNKNOWN',
      'attributes': attributesToMap(channel.attributes),
      'messages': messagesToMap(messages),
      'status': channel.status.toString(),
      'synchronizationStatus': channel.synchronizationStatus
          .toString(), // channel.conversationStatus.ChannelStatus
      'dateCreated': dateToString(channel.dateCreatedAsDate),
      'createdBy': channel.createdBy,
      'dateUpdated': dateToString(channel.dateUpdatedAsDate),
      'lastMessageDate': dateToString(channel.lastMessageDate),
      'lastMessageIndex': channel.lastMessageIndex,
    };
  }


  static Map<String, dynamic>? usersToMap(List<TwilioConversationsUser>? users) {
        var subscribedUsersMap = users!.map((user) =>  userToMap(user));
        var myUser = null;
        // try {
        //     if (TwilioConversationsPlugin.chatClient?.myUser != null) {
        //         myUser = TwilioConversationsPlugin.chatClient?.myUser
        //     }
        // } catch (e) {
        //    print("myUser is null ${e.toString()}");
        // }

        return {
                "subscribedUsers" : subscribedUsersMap,
                "myUser" : userToMap(myUser)
        };
    }

    static Map<String, dynamic>? userToMap(TwilioConversationsUser user) {
        if (user != null) {
            return {
                    "friendlyName" : user.friendlyName,
                   // "attributes" : attributes:Map(user.attributes),
                    "identity" : user.identity,
                    // "isOnline" : user.isOnline,
                    // "isNotifiable" : user.isNotifiable,
                    // "isSubscribed" : user.isSubscribed
            };
        } else {
            return {
                    "friendlyName" : "",
                    "attributes" : "",
                    "identity" : "",
                    "isOnline" : "",
                    "isNotifiable" : "",
                    "isSubscribed" : "",
            };
        }
    }

  static Map<String, dynamic>? attributesToMap(JSONValue? attributes) {
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
    if (date == null) return null;
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    return dateFormat.format(date);
  }

  static Map<String, dynamic> messageToMap(TwilioConversationsMessage message) {
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
