import 'dart:js_util';
import 'package:dio/dio.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/logging.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';

class MessagesMethods {
  Future<dynamic> getLastMessages(int count, String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channel = await promiseToFuture<TwilioConversationsChannel>(
          _chatClient!.getConversationBySid(channelSid));

      final messages =
          await promiseToFuture<JSPaginator<TwilioConversationsMessage>>(
              channel.getMessages(
                  count, channel.lastMessage?.index ?? 0, "backwards"));

      final messageList = await Future.wait(
          messages.items.map((message) => Mapper.messageToMap(message)));
      return messageList;
    } catch (e) {
      Logging.debug('error: getLastMessages ${e}');
      return null;
    }
  }

  Future<dynamic> sendMessage(
      Map<String, dynamic> messageOptions,
      String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      final channel =
          channels.items.firstWhere((element) => element.sid == channelSid);

      final messagePreparator = await channel.prepareMessage();

      if ((messageOptions["body"]) != null) {
        messagePreparator.setBody(messageOptions["body"]);
      } else {
        messagePreparator.setBody('');
      }

      if (messageOptions["attributes"] != null) {
        messagePreparator.setAttributes(jsify(messageOptions["attributes"]));
      }

      if (messageOptions["input"] != null &&
          (messageOptions["mimeType"] as String?) != null) {
        final input = messageOptions["input"] as String;
        final mimeType = messageOptions["mimeType"] as String?;

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
            .firstWhere((element) => element.sid == channelSid)
            .getMessages(50, 0, "forward"),
      );

      return await Mapper.messageToMap(
          messages.items.firstWhere((element) => element.index == index));
    } catch (e) {
      Logging.debug('error: sendMessage ${e}');
    }
  }

  Future<int?> setAllMessagesReadWithResult(String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      return await promiseToFuture<int>(channels.items
          .firstWhere((element) => element.sid == channelSid)
          .setAllMessagesRead());
    } catch (e) {
      Logging.debug('error: setAllMessagesReadWithResult ${e}');
      return 0;
    }
  }

  Future<dynamic> getMessagesDirection(
      int index,
      int count,
      String channelSid,
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
                  .firstWhere((element) => element.sid == channelSid)
                  .getMessages(count, index, direction));

      return await Future.wait(
          messages.items.map((message) => Mapper.messageToMap(message)));
    } catch (e) {
      Logging.debug('error: getMessagesDirection ${e}');
      return null;
    }
  }
}
