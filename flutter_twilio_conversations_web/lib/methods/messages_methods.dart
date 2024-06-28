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
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      final messages =
          await promiseToFuture<JSPaginator<TwilioConversationsMessage>>(
              channels.items
                  .firstWhere((element) => element.sid == _channel.sid)
                  .getMessages(50, 0, "forward"));

      final messageList = await Future.wait(
          messages.items.map((message) => Mapper.messageToMap(message)));
      return messageList;
    } catch (e) {
      TwilioConversationsClient.log('error: getLastMessages ${e}');
      return null;
    }
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

      final messagePreparator = await channel.prepareMessage();

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
      final index = await promiseToFuture<int>(
        messagePreparator.build().send(),
      );

      final messages =
          await promiseToFuture<JSPaginator<TwilioConversationsMessage>>(
        channels.items
            .firstWhere((element) => element.sid == _channel.sid)
            .getMessages(50, 0, "forward"),
      );

      return await Mapper.messageToMap(
          messages.items.firstWhere((element) => element.index == index));
    } catch (e) {
      TwilioConversationsClient.log('error: sendMessage ${e}');
    }
  }

  Future<int?> setAllMessagesReadWithResult(Channel _channel,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      return await promiseToFuture<int>(channels.items
          .firstWhere((element) => element.sid == _channel.sid)
          .setAllMessagesRead());
    } catch (e) {
      TwilioConversationsClient.log('error: setAllMessagesReadWithResult ${e}');
      return 0;
    }
  }

  Future<dynamic> getMessagesDirection(
      int index,
      int count,
      Channel _channel,
      TwilioWebClient.TwilioConversationsClient? _chatClient,
      String direction) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      final messages =
          await promiseToFuture<JSPaginator<TwilioConversationsMessage>>(
              channels.items
                  .firstWhere((element) => element.sid == _channel.sid)
                  .getMessages(count, index, direction));

      return await Future.wait(
          messages.items.map((message) => Mapper.messageToMap(message)));
    } catch (e) {
      TwilioConversationsClient.log('error: getMessagesDirection ${e}');
      return null;
    }
  }
}
