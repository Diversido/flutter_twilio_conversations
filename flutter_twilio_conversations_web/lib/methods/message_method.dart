import 'dart:convert';
import 'dart:io';
import 'dart:js_util';

import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';

class MessageMethods {
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

  Future<dynamic> sendMessage(MessageOptions options, Channel _channel,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      final channel =
          channels.items.firstWhere((element) => element.sid == _channel.sid);

      final optionsMapped = options.toMap();

      dynamic messagePreparator = await channel.prepareMessage();

      if ((optionsMapped["body"]) != null) {
        messagePreparator.setBody(optionsMapped["body"]);
      }

      if (optionsMapped["attributes"] != null) {
        messagePreparator.setAttributes(
            optionsMapped["attributes"] as Map<String, dynamic>?);
      }

      if (optionsMapped["input"] != null &&
          (optionsMapped["mimeType"] as String?) != null) {
        final input = optionsMapped["input"] as String;
        final mimeType = optionsMapped["mimeType"] as String?;

        final formData = dio.FormData.fromMap({
          "data": "{}",
          "files.image": await dio.MultipartFile.fromFile(
              "${documentDirectory.path}/picture.png",
              filename: "picture.png",
              contentType: MediaType('image', 'png'))
        });

        final media = File(input);
        Stream<String> lines = media
            .openRead()
            .transform(utf8.decoder) // Decode bytes to UTF-8.
            .transform(LineSplitter());
        messagePreparator.addMedia(
            input, mimeType, "image.jpeg", (mediaSid) {});
      } else {
        messagePreparator
            .build()
            .send()
            .then((value) => Mapper.messageToMap(value));
      }
    } catch (e) {
      print(e);
    }
  }
}
