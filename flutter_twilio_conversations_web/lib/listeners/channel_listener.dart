import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart'
    as TwilioClientConversation;
import 'package:flutter_twilio_conversations_web/interop/classes/member.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';

import 'package:flutter_twilio_conversations_web/listeners/base_listener.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';
import 'package:js/js.dart';

// TODO
// participantJoined
// participantLeft
// participantUpdated
// pushNotification

class ChannelEventListener extends BaseListener {
  final TwilioClientConversation.TwilioConversationsChannel _channel;
  final StreamController<Map<String, dynamic>> _channelStreamController;
  final TwilioConversationsPlugin pluginInstance;

  ChannelEventListener(
      this._channel, this._channelStreamController, this.pluginInstance) {}

  void addListeners() {
    debug('Adding chatClientEventListeners for ${_channel.sid}');
    _on('messageAdded', messageAdded);
    _on('messageUpdated', messageUpdated);
    _on('messageRemoved', messageRemoved);
    _on('participantJoined', participantJoined);
    _on('participantLeft', participantLeft);
    _on('participantUpdated', participantUpdated);
    _on('typingStarted', onTypingStarted);
    _on('typingEnded', onTypingEnded);
    _on('updated', onSynchronizationChanged);
  }

  void _on(String eventName, Function eventHandler) => _channel.on(
        eventName,
        allowInterop(eventHandler),
      );

  void _off(String eventName, Function eventHandler) => _channel.off(
        eventName,
        allowInterop(eventHandler),
      );

  messageAdded(dynamic message) async {
    debug('Message Added Channel Event');
    sendEvent("messageAdded", await Mapper.messageToMap(message));
  }

  messageUpdated(dynamic data) async {
    debug('Message Updated Channel Event');

    sendEvent("messageUpdated", {
      "message": await Mapper.messageToMap(data.message),
      "reason": {"type": "message", "value": data.reason.toString()}
    });
  }

  onTypingEnded(
      TwilioConversationsChannel channel, TwilioConversationsMember member) {
    debug(
        "ChannelListener.onTypingEnded => channelSid = ${channel.sid}, memberSid = ${member.sid}");
    sendEvent("typingEnded", {
      "channel": Mapper.channelToMap(pluginInstance, channel),
      "member": Mapper.memberToMap(member)
    });
  }

  onTypingStarted(
      TwilioConversationsChannel channel, TwilioConversationsMember member) {
    debug(
        "ChannelListener.onTypingStarted => channelSid = ${channel.sid}, memberSid = ${member.sid}");
    sendEvent("typingStarted", {
      "channel": Mapper.channelToMap(pluginInstance, channel),
      "member": Mapper.memberToMap(member)
    });
  }

  messageRemoved(TwilioConversationsMessage message) {
    debug("ChannelListener.onMessageDeleted => messageSid = ${message.sid}");
    sendEvent("messageDeleted", {"message": Mapper.messageToMap(message)});
  }

  participantJoined(TwilioConversationsMember member) {
    debug("ChannelListener.onMemberAdded => memberSid = ${member.sid}");
    sendEvent("memberAdded", {"member": Mapper.memberToMap(member)});
  }

  participantLeft(TwilioConversationsMember member) {
    debug("ChannelListener.onMemberDeleted => memberSid = ${member.sid}");
    sendEvent("memberDeleted", {"member": Mapper.memberToMap(member)});
  }

  participantUpdated(TwilioConversationsMember member, dynamic reason) {
    debug(
        "ChannelListener.onMemberUpdated => => memberSid = ${member.sid}, reason = $reason");
    sendEvent("memberUpdated", {
      "member": Mapper.memberToMap(member),
      "reason": {"type": "member", "value": reason.toString()}
    });
  }

  onSynchronizationChanged(TwilioConversationsChannel channel) {
    debug(
        "ChannelListener.onSynchronizationChanged => channelSid = ${channel.sid}");
    sendEvent("synchronizationChanged",
        {"channel": Mapper.channelToMap(pluginInstance, channel)});
  }

  sendEvent(String name, dynamic data, {ErrorInfo? e}) {
    final eventData = {
      "name": name,
      "data": data,
      "error": Mapper.errorInfoToMap(e),
    };
    _channelStreamController.add(eventData);
  }
}
