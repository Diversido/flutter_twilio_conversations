import 'dart:convert';
import 'dart:io';
import 'dart:js_util';

import 'package:dio/dio.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';

class MessagesMethods {
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
            .getMessages(50, 0, "forward"));

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
        messagePreparator.setAttributes(jsify(optionsMapped["attributes"]));
      }

      if (optionsMapped["input"] != null &&
          (optionsMapped["mimeType"] as String?) != null) {
        final input = optionsMapped["input"] as String;
        final mimeType = optionsMapped["mimeType"] as String?;

        final media = FormData.fromMap({
          'contentType': mimeType,
          'filename': DateTime.now().toIso8601String(),
          'media': await MultipartFile.fromFile(input, filename: 'upload.txt'),
        });

        messagePreparator.addMedia(media);
      }
      messagePreparator
          .build()
          .send()
          .then((value) => Mapper.messageToMap(value));
    } catch (e) {
      print(e);
    }
  }

  Future<int?> setAllMessagesReadWithResult(Channel _channel,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    final channels =
        await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
      _chatClient!.getSubscribedConversations(),
    );

    return await channels.items
        .firstWhere((element) => element.sid == _channel.sid)
        .setAllMessagesRead();
  }

  Future<dynamic> getMessagesDirection(
      int index,
      int count,
      Channel _channel,
      TwilioWebClient.TwilioConversationsClient? _chatClient,
      String direction) async {
    final channels =
        await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
      _chatClient!.getSubscribedConversations(),
    );

    return await channels.items
        .firstWhere((element) => element.sid == _channel.sid)
        .getMessages(50, index, direction);
  }
}
