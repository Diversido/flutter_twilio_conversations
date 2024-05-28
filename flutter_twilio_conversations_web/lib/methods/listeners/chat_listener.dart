import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioChatClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/methods/listeners/base_listener.dart';
import 'package:flutter_twilio_conversations_web/methods/mapper.dart';

class ChatClientEventListener extends BaseListener {
  final TwilioChatClient.TwilioConversationsClient _client;
  final StreamController<Map<String, dynamic>> _chatClientStreamController;
  final TwilioConversationsPlugin pluginInstance;

  ChatClientEventListener(
    this.pluginInstance,
    this._client,
    this._chatClientStreamController,
  );

  void addListeners() async {
    debug('Adding chatClientEventListeners for ${_client.connectionState}');
    _on('connectionStateChanged', connectionStateChange);
    _on('stateChanged', stateChanged);
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
    debug('Connection State Change ChatClient Event $connectionState');
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

  Future<void> stateChanged(String state) async {
    debug('State Changed ChatClient Event');
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

  void conversationUpdated(dynamic data) async {
    debug('Conversation Updated ChatClient Event');
    sendEvent(
      'channelUpdated',
      {
        "channel": Mapper.channelToMap(pluginInstance, data.conversation),
        "reason": {
          "type": "channel",
          "value": data.updateReasons,
        }
      },
    );
  }

  void conversationAdded(dynamic channelAdded) async {
    debug('Conversation Added ChatClient Event');
    sendEvent('channelAdded', {
      "channel": Mapper.channelToMap(pluginInstance, channelAdded),
      "chatClient":
          Mapper.chatClientToMap(pluginInstance, _client, [channelAdded])
    });
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
        "user": Mapper.userToMap(data),
        "reason": {
          "type": "user",
          "value": data.updateReasons,
        }
      },
    );
  }

  void userSubscribed(dynamic data) {
    debug('User Subscribed ChatClient Event');
    sendEvent(
      'userSubsubscribed',
      {
        "user": Mapper.userToMap(data),
      },
    );
  }

  void userUnsubscribed(dynamic data) {
    debug('User Unsubscribed ChatClient Event');

    sendEvent(
      'userUnsubsubscribed',
      {
        "user": Mapper.userToMap(data),
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

  sendEvent(String name, dynamic data, {ErrorInfo? e}) {
    final eventData = {
      "name": name,
      "data": data,
      "error": Mapper.errorInfoToMap(e),
    };
    _chatClientStreamController.add(eventData);
  }
}
