import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioChatClient;
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart'
    as TwilioClientConversation;

import 'package:flutter_twilio_conversations_web/methods/listeners/base_listener.dart';
import 'package:flutter_twilio_conversations_web/methods/mapper.dart';
import 'package:js/js.dart';

// TODO implement this listener
class ChannelEventListener extends BaseListener {
  final TwilioClientConversation.TwilioConversationsChannel _channel;
  final StreamController<Map<String, dynamic>> _channelStreamController;

  ChannelEventListener(this._channel, this._channelStreamController) {}

  void addListeners() {
    debug('Adding chatClientEventListeners for ${_channel.sid}');
    // _on('connectionStateChanged', connectionStateChange);
    
  }

  void _on(String eventName, Function eventHandler) => _channel.on(
        eventName,
        allowInterop(eventHandler),
      );

  void _off(String eventName, Function eventHandler) => _channel.off(
        eventName,
        allowInterop(eventHandler),
      );

  sendEvent(String name, dynamic data, {ErrorInfo? e}) {
    final eventData = {
      "name": name,
      "data": data,
      "error": Mapper.errorInfoToMap(e),
    };
    _channelStreamController.add(eventData);
  }
}
