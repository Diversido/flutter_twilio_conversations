import 'dart:js_util';

import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';

class ChannelMethods {
  Future<int> getMessagesCount(String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    final channels =
        await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
      _chatClient!.getSubscribedConversations(),
    );

    final messagesCount = await promiseToFuture<int>(channels.items
        .firstWhere((element) => element.sid == channelSid)
        .getMessagesCount());

    return messagesCount;
  }

  Future<int> getUnreadMessagesCount(String channelSid,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    final channels =
        await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
      _chatClient!.getSubscribedConversations(),
    );

    final unreadMessagesCount = await promiseToFuture<int>(channels.items
        .firstWhere((element) => element.sid == channelSid)
        .getUnreadMessagesCount());

    return unreadMessagesCount;
  }
}
