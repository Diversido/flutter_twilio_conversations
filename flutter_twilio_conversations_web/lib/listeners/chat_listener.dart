import 'dart:async';
import 'dart:js_util' as js_util;
import 'package:flutter_twilio_conversations_web/flutter_twilio_conversations_web.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioChatClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/push_notification.dart';
import 'package:flutter_twilio_conversations_web/listeners/base_listener.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';
import 'package:flutter_twilio_conversations_web/types/connection_state.dart';
import 'package:flutter_twilio_conversations_web/types/error_info.dart';

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
    _on('connectionStateChanged', connectionStateChanged);
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
    _on('pushNotification', pushNotification);
  }

  void _on(String eventName, Function eventHandler) => _client.on(
        eventName,
        js_util.allowInterop(eventHandler),
      );

  // ignore: unused_element
  void _off(String eventName, Function eventHandler) => _client.off(
        eventName,
        js_util.allowInterop(eventHandler),
      );

  void connectionStateChanged(String state) {
    debug('Connection State Change ChatClient Event $state');
    switch (state) {
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
    var initialized = false;
    if (state == 'initialized') {
      state = 'CONVERSATIONS_COMPLETED';
      initialized = true;

      channels = await js_util
          .promiseToFuture<JSPaginator<TwilioConversationsChannel>>(
        _client.getSubscribedConversations(),
      );
    }

    sendEvent('clientSynchronization', {
      "synchronizationStatus": state,
      "chatClient": await Mapper.chatClientToMap(
        pluginInstance,
        _client,
        channels?.items,
        initialized,
      ),
    });
  }

  void conversationUpdated(dynamic data) async {
    late String reason;
    final updateReason = js_util.getProperty(data, 'updateReasons');
    debug('Conversation Updated ChatClient Event ${updateReason}');

    switch (updateReason[0]) {
      case 'friendlyName':
        reason = 'FRIENDLY_NAME';
        break;
      case 'lastMessage':
        reason = 'LAST_MESSAGE';
        break;
      case 'uniqueName':
        reason = 'UNIQUE_NAME';
        break;
      case 'notificationLevel':
        reason = 'NOTIFICATION_LEVEL';
        break;
      default:
        return;
    }

    sendEvent(
      'channelUpdated',
      {
        "channel": await Mapper.channelToMap(pluginInstance, data.conversation),
        "reason": {
          "type": "channel",
          "value": reason,
        }
      },
    );
  }

  void conversationAdded(dynamic channelAdded) async {
    debug('Conversation Added ChatClient Event');
    sendEvent('channelAdded', {
      "channel": await Mapper.channelToMap(pluginInstance, channelAdded),
      "chatClient": await Mapper.chatClientToMap(
        pluginInstance,
        _client,
        [channelAdded],
        true,
      )
    });
  }

  void conversationJoined(dynamic channel) async {
    debug('Conversation Joined ChatClient Event');
    sendEvent('channelAdded', {
      "channel": await Mapper.channelToMap(pluginInstance, channel),
    });
  }

  void conversationLeft(dynamic data) async {
    debug('Conversation Left ChatClient Event');
    sendEvent(
      'channelDeleted',
      {
        "channel": await Mapper.channelToMap(pluginInstance, data.conversation),
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

  void tokenAboutToExpire() {
    debug('Token about to Expire ChatClient Event');
    sendEvent(
      'tokenAboutToExpire',
      {
        null,
      },
    );
  }

  void tokenExpired() {
    debug('Token Expired ChatClient Event');
    sendEvent(
      'tokenExpired',
      null,
    );
  }

  Future<void> userUpdated(dynamic data) async {
    debug('User Updated ChatClient Event');
    sendEvent(
      'userUpdated',
      {
        "user": await Mapper.userToMap(data, _client),
        "reason": {
          "type": "user",
          "value": data.updateReasons,
        }
      },
    );
  }

  Future<void> userSubscribed(dynamic data) async {
    debug('User Subscribed ChatClient Event');
    sendEvent(
      'userSubscribed',
      {
        "user": await Mapper.userToMap(data, _client),
      },
    );
  }

  Future<void> userUnsubscribed(dynamic data) async {
    debug('User Unsubscribed ChatClient Event');

    sendEvent(
      'userUnsubscribed',
      {
        "user": await Mapper.userToMap(data, _client),
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

  void pushNotification(PushNotification pushNotification) {
    debug('Push Notification ChatClient Event ${pushNotification.type}');

    if (pushNotification.type == "twilio.conversations.new_message") {
      sendEvent("newMessageNotification", {
        "channelSid": pushNotification.data?.conversationSid,
        "messageSid": pushNotification.data?.messageSid,
        "messageIndex": pushNotification.data?.messageIndex,
      });
    } else if (pushNotification.type ==
        "twilio.conversations.added_to_conversation") {
      sendEvent("addedToChannelNotification", {
        "channelSid": pushNotification.data?.conversationSid,
      });
    } else if (pushNotification.type ==
        "twilio.conversations.removed_from_conversation") {
      sendEvent("removedFromChannelNotification", {
        "channelSid": pushNotification.data?.conversationSid,
      });
    }
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
