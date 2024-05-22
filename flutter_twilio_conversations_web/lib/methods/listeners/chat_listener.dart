import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioChatClient;
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart'
    as TwilioClientConversation;
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/paginator.dart';
import 'package:flutter_twilio_conversations_web/methods/listeners/base_listener.dart';
import 'package:flutter_twilio_conversations_web/methods/mapper.dart';
import 'package:js/js.dart';

class ChatClientEventListener extends BaseListener {
  final TwilioChatClient.TwilioConversationsClient _client;
  // final StreamController<BaseChatClientEvent> _chatClientStreamController; //TODO broken
  final StreamController<Map<String, dynamic>> _chatClientStreamController;
  final TwilioConversationsPlugin pluginInstance;

  ChatClientEventListener(
      this.pluginInstance, this._client, this._chatClientStreamController) {}

  void addListeners() {
    debug('Adding chatClientEventListeners for ${_client.connectionState}');
    _on('connectionStateChanged', connectionStateChange);
    _on('stateChanged', stateChanged);
    _on('connectionError', connectionError);
    _on('conversationAdded', conversationAdded);
    _on('conversationJoined', conversationJoined);
    _on('conversationLeft', conversationLeft);
    _on('conversationUpdated', conversationUpdated);
  }

  void _on(String eventName, Function eventHandler) => _client.on(
        eventName,
        allowInterop(eventHandler),
      );

  void _off(String eventName, Function eventHandler) => _client.off(
        eventName,
        allowInterop(eventHandler),
      );

  void connectionStateChange(String connectionState) {
    debug('ConnectionStateChange ChatClient Event $connectionState');
    switch (connectionState) {
      case "connecting":
        _client.connectionState = ConnectionState.CONNECTING;
        break;
      case "connected":
        _client.connectionState = ConnectionState.CONNECTED;
        break;
      case "disconnected":
        _client.connectionState = ConnectionState.DISCONNECTED;
        break;
      case "denied":
        _client.connectionState = ConnectionState.DENIED;
        break;
      default:
        _client.connectionState = ConnectionState.UNKNOWN;
        break;
    }
    _chatClientStreamController.add(ConnectionStateChange(
      _client.connectionState,
    ).toJson());
  }

  void stateChanged(String state) {
    print('p: stateChanged $state sync');
    if (state == 'initialized') {
      state = 'CONVERSATIONS_COMPLETED';
    }
    sendEvent('clientSynchronization',
        {"synchronizationStatus": state});
  }

  void conversationAdded(dynamic channelAdded) async {
    TwilioClientConversation.TwilioConversationsChannel channel = channelAdded;
    sendEvent('channelAdded',
        {"channel": Mapper.channelToMap(pluginInstance, channel)});
  }

  void conversationUpdated(dynamic channelUpdated, dynamic reason) async {
    TwilioClientConversation.TwilioConversationsChannel channel =
        channelUpdated;
    sendEvent(
      'channelUpdated',
      {
        "channel": Mapper.channelToMap(pluginInstance, channel),
        "reason": {
          "type": "channel",
          "value": reason,
        }
      },
    );
  }

  // override fun onConversationAdded(conversation: Conversation?) {
  // Log.d("TwilioInfo", "ChatListener.onConversationAdded => conversation '${conversation?.sid}' added")
  // sendEvent("channelAdded", mapOf(
  // "channel" to Mapper.channelToMap(pluginInstance, conversation!!)
  // ))
  // }

  void conversationJoined(dynamic channelJoined) async {
    debug('conversationJoined');

    TwilioClientConversation.TwilioConversationsChannel channel = channelJoined;
    // TwilioPaginator paginator =
    //     await promiseToFuture(conversation.getMessages());
    // var interesting = paginator.toModel();
    // TwilioConversationsMessage message = interesting.items[0];
    // print('message: ${message.body}');
    // _chatClientStreamController.add(
    //   ChannelAdded(_client.toModel().connectionState, channel.toModel()),
    // );
  }

  void conversationLeft(dynamic conversationJoined) {
    debug('conversationLeft');
    // TwilioClientConversation.TwilioConversationsConversation conversation;
    // conversation = conversationJoined;
    // _chatClientStreamController.add(
    //   ConversationJoined(_client.toModel(), conversation.toModel()),
    // );
  }

  void connectionError(dynamic data) {
    debug('Added ConnectionStateChange ChatClient Event');
    // _chatClientStreamController.add(ConnectError(
    // _client.toModel().connectionState,
    // "this is an error")); // TODO Nic the data is probably the connection state and their is probably a region
  }

  /*boolean terminal - Twilsock will stop connection attempts if true
string message - the error message of the root cause
number? httpStatusCode - http status code if available
number? errorCode - Twilio public error code if available */

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

  sendEvent(String name, dynamic data, {ErrorInfo? e}) {
    final eventData = {
      "name": name,
      "data": data,
      "error": Mapper.errorInfoToMap(e),
    };
    print('p: sending chat event ${eventData['name']}');
    _chatClientStreamController.add(eventData);
  }
}
