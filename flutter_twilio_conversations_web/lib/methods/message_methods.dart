import 'dart:js_util';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/logging.dart';

class MessageMethods {
  void getChannel() {}
  void updateMessageBody() {}
  void setAttributes() {}

  Future<dynamic> getMedia(String _channelSid, int _messageIndex,
      TwilioWebClient.TwilioConversationsClient _chatClient) async {
    try {
      final message =
          await getMessageByIndex(_channelSid, _messageIndex, _chatClient);
      final contentUrl = await promiseToFuture(
          message!.attachedMedia[0].getContentTemporaryUrl());
      return contentUrl;
    } catch (e) {
      Logging.debug('error: getLastMessages ${e}');
      return null;
    }
  }

  Future<TwilioConversationsMessage?> getMessageByIndex(
      String _channelSid,
      int _messageIndex,
      TwilioWebClient.TwilioConversationsClient _chatClient) async {
    try {
      final channels =
          await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _chatClient.getSubscribedConversations(),
      );

      final messages =
          await promiseToFuture<JSPaginator<TwilioConversationsMessage>>(
              channels.items
                  .firstWhere((element) => element.sid == _channelSid)
                  .getMessages(2, _messageIndex, "forward"));

      return messages.items[0];
    } catch (e) {
      Logging.debug('error: getMessageByIndex ${e}');
      return null;
    }
  }
}
