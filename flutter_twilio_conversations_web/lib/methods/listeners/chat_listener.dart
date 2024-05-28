import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioChatClient;
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart'
    as TwilioClientConversation;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/methods/listeners/base_listener.dart';
import 'package:flutter_twilio_conversations_web/methods/mapper.dart';
import 'package:js/js.dart';

class ChatClientEventListener extends BaseListener {
  final TwilioChatClient.TwilioConversationsClient _client;
  final StreamController<Map<String, dynamic>> _chatClientStreamController;
  final TwilioConversationsPlugin pluginInstance;

  ChatClientEventListener(
    this.pluginInstance,
    this._client,
    this._chatClientStreamController,
  );

  void addListeners() {
    debug('Adding chatClientEventListeners for ${_client.connectionState}');
    _on('connectionStateChanged', connectionStateChange);
    _on('stateChanged', clientSynchronization);
    _on('connectionError', connectionError);
    _on('conversationAdded', conversationAdded);
    _on('conversationJoined', conversationJoined);
    _on('conversationLeft', conversationLeft);
    _on('conversationRemoved', onRemovedFromConversationNotification);
    _on('tokenAboutToExpire', tokenAboutToExpire);
    _on('tokenExpired', tokenExpired);
    _on('userUpdated', userUpdated);
    _on('userSubscribed', userSubscribed);
    _on('userUnsubscribed', userUnsubscribed);
    _on('conversationUpdated', conversationUpdated);
// TODO check the android and IOS chat listener and use the same events as there

// conversationLeft
// messageAdded
// messageRemoved
// messageUpdated
// participantJoined
// participantLeft
// participantUpdated
// pushNotification
// typingEnded
// typingStarted
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
    sendEvent(
      'connectionStateChange',
      {
        'connectionState',
        Mapper.connectionStateToString(_client.connectionState),
      },
    );
  }

  Future<void> clientSynchronization(String state) async {
    debug('Client Synchronization ChatClient Event $state');
    JSPaginator<TwilioConversationsChannel>? channels = null;
    if (state == 'initialized') {
      state = 'CONVERSATIONS_COMPLETED';

      channels = await promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _client.getSubscribedConversations(),
      );
    }
  
    sendEvent('clientSynchronization', {
      "synchronizationStatus": state,
      "chatClient":
          Mapper.chatClientToMap(pluginInstance, _client, channels?.items)
    });
  }

  void conversationAdded(dynamic channelAdded) async {
    TwilioClientConversation.TwilioConversationsChannel channel = channelAdded;

    sendEvent('channelAdded', {
      "channel": Mapper.channelToMap(pluginInstance, channel),
      //  "chatClient": Mapper.chatClientToMap(pluginInstance, _client, channel)
    });
  }

  void conversationUpdated(dynamic data) async {
    TwilioClientConversation.TwilioConversationsChannel channel =
        data.conversation;
    sendEvent(
      'channelUpdated',
      {
        "channel": Mapper.channelToMap(pluginInstance, channel),
        "reason": {
          "type": "channel",
          "value": data.updateReasons,
        }
      },
    );
  }

  void conversationJoined(dynamic channel) async {
    debug('Conversation Joined ChatClient Event');

    sendEvent('channelAdded', {
      "channel": Mapper.channelToMap(pluginInstance, channel),
    });
  }

  void conversationLeft(dynamic data) {
    debug('Conversation Left ChatClient Event');
    sendEvent(
      'channelDeleted',
      {
        "channel": Mapper.channelToMap(pluginInstance, data.conversation),
      },
    );
  }

  void onRemovedFromConversationNotification(dynamic data) {
    debug('Conversation No Longer Visible ChatClient Event');
    sendEvent(
      'removedFromChannelNotification',
      {
        "channelSid": data.sid,
      },
    );
  }

  void tokenAboutToExpire(dynamic data) {
    debug('Token about to Expire ChatClient Event');
    sendEvent(
      'tokenAboutToExpire',
      {
        null,
      },
    );
  }

  void tokenExpired(dynamic data) {
    debug('Token Expired ChatClient Event');
    sendEvent(
      'tokenExpired',
      null,
    );
  }

  void userUpdated(dynamic data) {
    debug('User Updated ChatClient Event');
    sendEvent(
      'userUpdated',
      {
        "user": Mapper.userToMap(data.user),
        "reason": {
          "type": "user",
          "value": data.updateReasons,
        }
      },
    );
  }

  void userSubscribed(dynamic data) {
    debug('User subscribed ChatClient Event');
    sendEvent(
      'userSubsubscribed',
      {
        "user": Mapper.userToMap(data.user),
      },
    );
  }

  void userUnsubscribed(dynamic data) {
    debug('User unsubscribed ChatClient Event');
    sendEvent(
      'userUnsubsubscribed',
      {
        "user": Mapper.userToMap(data.user),
      },
    );
  }

  void connectionError(dynamic data) {
    debug('Connection Error for ChatClient Event');
    sendEvent(
      'error',
      null,
      e: data,
    );
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
    print('p: chat_listener sending chat event ${eventData['name']}');
    _chatClientStreamController.add(eventData);
  }
}
