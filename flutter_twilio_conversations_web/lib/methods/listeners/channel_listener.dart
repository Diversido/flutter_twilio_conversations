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
// messageAdded
// messageRemoved
// messageUpdated
// participantJoined
// participantLeft
// participantUpdated
// pushNotification
// typingEnded
// typingStarted
class ChannelEventListener extends BaseListener {
  final TwilioClientConversation.TwilioConversationsChannel _channel;
  final StreamController<Map<String, dynamic>> _channelStreamController;

  ChannelEventListener(this._channel, this._channelStreamController) {}

  void addListeners() {
    debug('Adding chatClientEventListeners for ${_channel.sid}');
    _on('messageAdded', messageAdded);
    _on('messageUpdated', messageUpdated);
  }

  void _on(String eventName, Function eventHandler) => _channel.on(
        eventName,
        allowInterop(eventHandler),
      );

  void _off(String eventName, Function eventHandler) => _channel.off(
        eventName,
        allowInterop(eventHandler),
      );

  messageAdded(dynamic message) {
    debug('Message Added Channel Event');
    sendEvent("messageAdded", Mapper.messageToMap(message));
  }

  messageUpdated(dynamic data) {
    debug('Message Updated Channel Event');

    sendEvent("messageUpdated", {
      "message": Mapper.messageToMap(data.message),
      "reason": {"type": "message", "value": data.reason.toString()}
    });
  }

  // override fun onMessageDeleted(message: Message) {
  //     Log.d("TwilioInfo", "ChannelListener.onMessageDeleted => messageSid = ${message.sid}")
  //     sendEvent("messageDeleted", mapOf("message" to Mapper.messageToMap(message)))
  // }

  // override fun onParticipantAdded(member: Participant) {
  //     Log.d("TwilioInfo", "ChannelListener.onMemberAdded => memberSid = ${member.sid}")
  //     sendEvent("memberAdded", mapOf("member" to Mapper.memberToMap(member)))
  // }

  // override fun onParticipantUpdated(member: Participant, reason: Participant.UpdateReason) {
  //     Log.d("TwilioInfo", "ChannelListener.onMemberUpdated => memberSid = ${member.sid}, reason = $reason")
  //     sendEvent("memberUpdated", mapOf(
  //             "member" to Mapper.memberToMap(member),
  //             "reason" to mapOf(
  //                     "type" to "member",
  //                     "value" to reason.toString()
  //             )
  //     ))
  // }

  // override fun onParticipantDeleted(member: Participant) {
  //     Log.d("TwilioInfo", "ChannelListener.onMemberDeleted => memberSid = ${member.sid}")
  //     sendEvent("memberDeleted", mapOf("member" to Mapper.memberToMap(member)))
  // }

  // override fun onTypingStarted(channel: Conversation, member: Participant) {
  //     Log.d("TwilioInfo", "ChannelListener.onTypingStarted => channelSid = ${channel.sid}, memberSid = ${member.sid}")
  //     sendEvent("typingStarted", mapOf("channel" to Mapper.channelToMap(pluginInstance, channel), "member" to Mapper.memberToMap(member)))
  // }

  // override fun onTypingEnded(channel: Conversation, member: Participant) {
  //     Log.d("TwilioInfo", "ChannelListener.onTypingEnded => channelSid = ${channel.sid}, memberSid = ${member.sid}")
  //     sendEvent("typingEnded", mapOf("channel" to Mapper.channelToMap(pluginInstance, channel), "member" to Mapper.memberToMap(member)))
  // }

  // override fun onSynchronizationChanged(channel: Conversation) {
  //     Log.d("TwilioInfo", "ChannelListener.onSynchronizationChanged => channelSid = ${channel.sid}")
  //     sendEvent("synchronizationChanged", mapOf("channel" to Mapper.channelToMap(pluginInstance, channel)))
  // }

  // private fun sendEvent(name: String, data: Any?, e: ErrorInfo? = null) {
  //     val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
  //     events.success(eventData)
  // }

  sendEvent(String name, dynamic data, {ErrorInfo? e}) {
    final eventData = {
      "name": name,
      "data": data,
      "error": Mapper.errorInfoToMap(e),
    };
    _channelStreamController.add(eventData);
  }
}
