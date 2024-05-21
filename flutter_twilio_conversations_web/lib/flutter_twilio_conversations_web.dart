import 'dart:async';
import 'dart:js_util';

import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart'
    as TwilioClientConversation;
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/methods/conversation_client.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioChatClient;
import 'package:flutter_twilio_conversations_web/methods/listeners/chat_listener.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class TwilioConversationsPlugin extends FlutterTwilioConversationsPlatform {
  static TwilioChatClient.TwilioConversationsClient? _chatClient;
  static ChatClientEventListener? _chatClientListener;

  static final _chatClientStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Registers this class as the default instance of [FlutterTwilioConversationsPlatform].
  static void registerWith(Registrar registrar) {
    FlutterTwilioConversationsPlatform.instance = TwilioConversationsPlugin();
  }

  void _onConnected() async {
    final chatClient = _chatClient;
    if (chatClient != null) {
      _chatClientListener =
          ChatClientEventListener(chatClient, _chatClientStreamController);
      _chatClientListener!.addListeners();

      final _clientModel =
          ConnectionStateChange(_chatClient!.toModel().connectionState);
      _chatClientStreamController.add(_clientModel.toJson());
      _chatClientStreamController.onListen = null;
    }
  }

  @override
  Future<dynamic> create(String token, Properties properties) async {
    _chatClientStreamController.onListen = _onConnected;
    try {
      _chatClient =
          await createTwilioConversationsClient(token, {"logLevel": "Debug"});
      print(_chatClient?.user.identity);
      var clientModel = _chatClient!.toModel();
      return clientModel.toMap();
    } catch (e) {
      print('error: createConversation ${e}');
    }
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) async {
    throw UnimplementedError('createChannel() has not been implemented.');
  }

  @override
  Future<dynamic> getChannel(String channelSidOrUniqueName) async {
    try {
      TwilioConversationsChannel _conversation = await promiseToFuture(
          _chatClient?.getChannelBySid(channelSidOrUniqueName));
      return _conversation.toModel();
      // then does this conversation need to be subscribed to?
      //   await getTwilioConversationBySidOrUniqueName(channelSidOrUniqueName);
    } catch (e) {}
    return null;
  }

  @override
  Future<void> declineInvitationChannel(String channelSid) {
    // TODO: implement declineInvitationChannel
    throw UnimplementedError();
  }

  @override
  Future<void> destroyChannel(String channelSid) {
    // TODO: implement destroyChannel
    throw UnimplementedError();
  }

  @override
  Future<String> getFriendlyNameChannel(String channelSid) {
    // TODO: implement getFriendlyNameChannel
    throw UnimplementedError();
  }

  @override
  Future<int> getMembersCountChannel(String channelSid) {
    // TODO: implement getMembersCountChannel
    throw UnimplementedError();
  }

  @override
  Future<int> getMessagesCountChannel(String channelSid) {
    // TODO: implement getMessagesCountChannel
    throw UnimplementedError();
  }

  @override
  Future<String> getNotificationLevelChannel(String channelSid) {
    // TODO: implement getNotificationLevelChannel
    throw UnimplementedError();
  }

  @override
  Future<String> getUniqueNameChannel(String channelSid) {
    // TODO: implement getUniqueNameChannel
    throw UnimplementedError();
  }

  @override
  Future<int> getUnreadMessagesCountChannel(String channelSid) {
    // TODO: implement getUnreadMessagesCountChannel
    throw UnimplementedError();
  }

  @override
  Future<void> joinChannel(String channelSid) {
    // TODO: implement joinChannel
    throw UnimplementedError();
  }

  @override
  Future<void> leaveChannel(String channelSid) {
    // TODO: implement leaveChannel
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> setAttributesChannel(
      String channelSid, Map<String, dynamic> attributes) {
    // TODO: implement setAttributesChannel
    throw UnimplementedError();
  }

  @override
  Future<String> setFriendlyNameChannel(String channelSid, String friendlyName) {
    // TODO: implement setFriendlyNameChannel
    throw UnimplementedError();
  }

  @override
  Future<String> setNotificationLevelChannel(
      String channelSid, String notificationLevel) {
    // TODO: implement setNotificationLevelChannel
    throw UnimplementedError();
  }

  @override
  Future<String> setUniqueNameChannel(String channelSid, String uniqueName) {
    // TODO: implement setUniqueNameChannel
    throw UnimplementedError();
  }

  @override
  Future<void> typingChannel(String channelSid) {
    // TODO: implement typingChannel
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>> chatClientStream() {
    print('TwilioConversationsPlugin.create => starting stream');
    return _chatClientStreamController.stream;
  }
}
