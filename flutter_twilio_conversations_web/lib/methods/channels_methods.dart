import 'dart:js_util';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/mapper.dart';

class ChannelsMethods {
  Future<Map<String, dynamic>?> getChannel(
      String channelSidOrUniqueName,
      TwilioWebClient.TwilioConversationsClient? _chatClient,
      TwilioConversationsPlugin pluginInstance) async {
    try {
      final channelBySid = await promiseToFuture<TwilioConversationsChannel>(
        _chatClient?.getConversationBySid(channelSidOrUniqueName),
      );
      if (channelBySid.sid == "") {
        final channelByUniqueName =
            await promiseToFuture<TwilioConversationsChannel>(
          _chatClient?.getConversationBySid(channelSidOrUniqueName),
        );
        return Mapper.channelToMap(pluginInstance, channelByUniqueName);
      } else {
        return Mapper.channelToMap(pluginInstance, channelBySid);
      }
    } catch (e) {
      print('error: getChannel ${e}');
      return null;
    }
  }
}
