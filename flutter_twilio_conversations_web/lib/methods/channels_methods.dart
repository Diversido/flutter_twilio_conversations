import 'dart:js_util';

import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;

class ChannelsMethods {
  getChannel(String channelSidOrUniqueName,
      TwilioWebClient.TwilioConversationsClient? _chatClient) async {
    final channelBySid = await promiseToFuture<TwilioConversationsChannel>(
      _chatClient?.getConversationBySid(channelSidOrUniqueName),
    );
    if (channelBySid == null) {
      final channelByUniqueName =
          await promiseToFuture<TwilioConversationsChannel>(
        _chatClient?.getConversationBySid(channelSidOrUniqueName),
      );
      return channelByUniqueName;
    } else {
      return channelBySid;
    }
  }
}
