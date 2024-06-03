import 'dart:async';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/methods/listeners/chat_listener.dart';
import 'package:flutter_twilio_conversations_web/methods/mapper.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'methods/listeners/channel_listener.dart';

// TODO look at channel listeners and controllers
class TwilioConversationsPlugin extends FlutterTwilioConversationsPlatform {
  static TwilioWebClient.TwilioConversationsClient? _chatClient;
  static ChatClientEventListener? _chatClientListener;

  static final _chatClientStreamController =
      StreamController<Map<String, dynamic>>.broadcast();


  // TODO update dynamic in both maps
  Map<String, ChannelEventListener> channelChannels = {};
  Map<String, StreamController<Map<String, dynamic>>> channelListeners = {};

  /// Registers this class as the default instance of [FlutterTwilioConversationsPlatform].
  static void registerWith(Registrar registrar) {
    FlutterTwilioConversationsPlatform.instance = TwilioConversationsPlugin();
  }

  @override
  Future<dynamic> create(String token, Properties properties) async {
    try {
      _chatClient = await TwilioWebClient.TwilioConversationsClient(token);

      _chatClientListener = ChatClientEventListener(
        this,
        _chatClient!,
        _chatClientStreamController,
      );

      _chatClientListener!.addListeners();

      return await Mapper.chatClientToMap(this, _chatClient!, []);
    } catch (e) {
      print('error: createConversation ${e}');
    }
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) async {
    throw UnimplementedError('createChannel() has not been implemented.');
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) {
    throw UnimplementedError('getChannel() has not been implemented.');
  }

  @override
  Future<void> declineInvitationChannel(String channelSid) {
    print('web event: declineInvitationChannel');
    // TODO: implement declineInvitationChannel
    throw UnimplementedError();
  }

  @override
  Future<void> destroyChannel(String channelSid) {
    print('web event: destroyChannel');
    // TODO: implement destroyChannel
    throw UnimplementedError();
  }

  @override
  Future<String> getFriendlyNameChannel(String channelSid) {
    print('web event: getFriendlyNameChannel');
    // TODO: implement getFriendlyNameChannel
    throw UnimplementedError();
  }

  @override
  Future<int> getMembersCountChannel(String channelSid) {
    print('web event: getMembersCountChannel');
    // TODO: implement getMembersCountChannel
    throw UnimplementedError();
  }

  @override
  Future<int> getMessagesCountChannel(String channelSid) {
    print('web event: getMessagesCountChannel');
    // TODO: implement getMessagesCountChannel
    throw UnimplementedError();
  }

  @override
  Future<String> getNotificationLevelChannel(String channelSid) {
    print('web event: getNotificationLevelChannel');
    // TODO: implement getNotificationLevelChannel
    throw UnimplementedError();
  }

  @override
  Future<String> getUniqueNameChannel(String channelSid) {
    print('web event: getUniqueNameChannel');
    // TODO: implement getUniqueNameChannel
    throw UnimplementedError();
  }

  @override
  Future<int> getUnreadMessagesCountChannel(String channelSid) {
    print('web event: getUnreadMessagesCountChannel');
    // TODO: implement getUnreadMessagesCountChannel
    throw UnimplementedError();
  }

  @override
  Future<void> joinChannel(String channelSid) {
    print('web event: joinChannel');
    // TODO: implement joinChannel
    throw UnimplementedError();
  }

  @override
  Future<void> leaveChannel(String channelSid) {
    print('web event: leaveChannel');
    // TODO: implement leaveChannel
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> setAttributesChannel(
      String channelSid, Map<String, dynamic> attributes) {
    print('web event: setAttributesChannel');
    // TODO: implement setAttributesChannel
    throw UnimplementedError();
  }

  @override
  Future<String> setFriendlyNameChannel(
      String channelSid, String friendlyName) {
    print('web event: setFriendlyNameChannel');
    // TODO: implement setFriendlyNameChannel
    throw UnimplementedError();
  }

  @override
  Future<String> setNotificationLevelChannel(
      String channelSid, String notificationLevel) {
    print('web event: setNotificationLevelChannel');
    // TODO: implement setNotificationLevelChannel
    throw UnimplementedError();
  }

  @override
  Future<String> setUniqueNameChannel(String channelSid, String uniqueName) {
    print('web event: setUniqueNameChannel');
    // TODO: implement setUniqueNameChannel
    throw UnimplementedError();
  }

  @override
  Future<void> typingChannel(String channelSid) {
    print('web event: typingChannel');
    // TODO: implement typingChannel
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>> chatClientStream() {
    print('TwilioConversationsPlugin.create => starting stream');
    return _chatClientStreamController.stream;
  }

  @override
  Stream<Map<String, dynamic>> channelStream(String channelId) {
    print('TwilioConversationsPlugin.channel => starting stream');
    return channelListeners[channelId]!.stream;
  }

  Future<void> platformDebug(bool dart, bool native, bool sdk) {
    throw UnimplementedError('debug() has not been implemented');
  }
}
