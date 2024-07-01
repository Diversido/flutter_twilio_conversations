import 'dart:js_util';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/logging.dart';

class ChannelMethods {
  Future<int> getMessagesCount(String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      final messagesCount = await promiseToFuture<int>(channels.items
          .firstWhere((element) => element.sid == channelSid)
          .getMessagesCount());

      return messagesCount;
    } catch (e) {
      Logging.debug('error: getMessagesCount ${e}');
      return 0;
    }
  }

  Future<int> getUnreadMessagesCount(String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      final unreadMessagesCount = await promiseToFuture<int>(channels.items
          .firstWhere((element) => element.sid == channelSid)
          .getUnreadMessagesCount());

      return unreadMessagesCount;
    } catch (e) {
      Logging.debug('error: getUnreadMessagesCount ${e}');
      return 0;
    }
  }

  Future<void> typing(String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient!.getSubscribedConversations(),
      );

      await promiseToFuture<int>(channels.items
          .firstWhere((element) => element.sid == channelSid)
          .typing());
    } catch (e) {
      Logging.debug('error: typing ${e}');
    }
  }
}
