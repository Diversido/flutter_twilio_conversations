import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';

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
      TwilioConversationsClient.log('error: getMessagesCount ${e}');
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
      TwilioConversationsClient.log('error: getUnreadMessagesCount ${e}');
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
      TwilioConversationsClient.log('error: typing ${e}');
    }
  }
}
