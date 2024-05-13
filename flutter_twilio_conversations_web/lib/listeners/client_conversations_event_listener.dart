import 'dart:async';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/listeners/base_listener.dart';
import 'package:js/js.dart';

class ChatClientEventListener extends BaseListener {
  final TwilioConversationsClient _client;
  final StreamController<BaseChatClientEvent> _chatClientStreamController;

  ChatClientEventListener(this._client, this._chatClientStreamController) {
    // _addPriorRemoteParticipantListeners();
  }

  void addListeners() {
    debug('Adding chatClientEventListeners for ${_client.connectionState}');
    _on('ConnectionStateChange', connectionStateChange);
    _on('ConnectionError', connectionError);
    // _on('participantConnected', onParticipantConnected);
    // _on('participantDisconnected', onParticipantDisconnected);
  }

  void _on(String eventName, Function eventHandler) => _client.on(
        eventName,
        allowInterop(eventHandler),
      );

  void _off(String eventName, Function eventHandler) => _client.off(
        eventName,
        allowInterop(eventHandler),
      );

  void connectionStateChange(TwilioConversationsClient chatClient) {
    debug('Added ConnectionStateChange ChatClient Event');
    _chatClientStreamController.add(ConnectionStateChange(
      chatClient.toModel(),
    ));
  }

  void connectionError(TwilioConversationsClient chatClient) {
    debug('Added ConnectionStateChange ChatClient Event');
    _chatClientStreamController
        .add(ConnectError(chatClient.toModel(), "this is an error"));
  }

  // void onParticipantConnected(RemoteParticipant participant) {
  //   _roomStreamController.add(ParticipantConnected(_room.toModel(), participant.toModel()));
  //   debug('Added ParticipantConnected Room Event');

  //   final remoteParticipantListener = RemoteParticipantEventListener(participant, _remoteParticipantController);
  //   remoteParticipantListener.addListeners();
  //   _remoteParticipantListeners[participant.sid] = remoteParticipantListener;
  // }

  // void onParticipantDisconnected(RemoteParticipant participant) {
  //   _roomStreamController.add(
  //     ParticipantDisconnected(_room.toModel(), participant.toModel()),
  //   );
  //   final remoteParticipantListener = _remoteParticipantListeners.remove(participant.sid);
  //   remoteParticipantListener?.removeListeners();
  //   debug('Added ParticipantDisconnected Room Event');
  // }
}
