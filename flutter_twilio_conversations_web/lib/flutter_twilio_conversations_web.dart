import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/listeners/chat_listener.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';
import 'package:flutter_twilio_conversations_web/methods/channel_methods.dart';
import 'package:flutter_twilio_conversations_web/methods/channels_methods.dart';
import 'package:flutter_twilio_conversations_web/methods/message_methods.dart';
import 'package:flutter_twilio_conversations_web/methods/messages_methods.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'listeners/channel_listener.dart';

class TwilioConversationsPlugin extends FlutterTwilioConversationsPlatform {
  static TwilioWebClient.TwilioConversationsClient? _chatClient;
  static ChatClientEventListener? _chatClientListener;

  static final _chatClientStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Map<String, ChannelEventListener> channelChannels = {};
  Map<String, StreamController<Map<String, dynamic>>> channelListeners = {};

  /// Registers this class as the default instance of [FlutterTwilioConversationsPlatform].
  static void registerWith(Registrar registrar) {
    FlutterTwilioConversationsPlatform.instance = TwilioConversationsPlugin();
  }

  @override
  Future<dynamic> createChatClient(String token, Properties properties) async {
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

  Future<void> updateToken(String token) async {
    _chatClient =
        await promiseToFuture<TwilioWebClient.TwilioConversationsClient>(
            _chatClient!.updateToken(token));
  }

  Future<void> shutdown() async {
    await promiseToFuture<void>(_chatClient!.shutdown());
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) async {
    throw UnimplementedError('createChannel() has not been implemented.');
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) async {
    return await ChannelsMethods()
        .getChannel(channelSidOrUniqueName, _chatClient, this);
  }

  Future<dynamic> getPublicChannelsList() async {
    throw UnimplementedError(
        'getPublicChannelsList() has not been implemented.');
  }

  Future<dynamic> getUserChannelsList() async {
    throw UnimplementedError('getUserChannelsList() has not been implemented.');
  }

  Future<void> unsubscribe(String? identity) async {
    throw UnimplementedError('unsubscribe() has not been implemented.');
  }

  Future<dynamic> getMembersByIdentity(String identity) async {
    throw UnimplementedError(
        'getMembersByIdentity() has not been implemented.');
  }

  Future<dynamic> getMember(String channelSid, String identity) async {
    throw UnimplementedError('getMember() has not been implemented');
  }

  Future<dynamic> getMembersList(String channelSid) async {
    throw UnimplementedError('getMembersList() has not been implemented');
  }

  Future<bool?> addByIdentity(String channelSid, String identity) async {
    throw UnimplementedError('addByIdentity() has not been implemented');
  }

  Future<bool?> removeByIdentity(String channelSid, String identity) async {
    throw UnimplementedError('removeByIdentity() has not been implemented');
  }

  Future<bool?> inviteByIdentity(String channelSid, String identity) async {
    throw UnimplementedError('inviteByIdentity() has not been implemented');
  }

  Future<dynamic> setAttributesMember(
      String sid, String? channelSid, Map<String, dynamic> attributes) async {
    throw UnimplementedError('setAttributesMember() has not been implemented');
  }

  Future<dynamic> memberGetAndSubscribeUser(
      String? identity, String? sid) async {
    throw UnimplementedError('getAndSubscribeUser() has not been implemented');
  }

  Future<dynamic> memberGetUserDescriptor(
      String? identity, String? channelSid) async {
    throw UnimplementedError(
        'memberGetUserDescriptor() has not been implemented');
  }

  Future<void> declineInvitationChannel(String channelSid) {
    throw UnimplementedError(
        'declineInvitationChannel() has not been implemented');
  }

  Future<dynamic> getAndSubscribeUser(String identity) async {
    throw UnimplementedError('getAndSubscribeUser() has not been implemented.');
  }

  Future<dynamic> getUserDescriptor(String identity) async {
    throw UnimplementedError('getUserDescriptor() has not been implemented.');
  }

  Future<dynamic> getChannelUserDescriptors(String channelSid) async {
    throw UnimplementedError(
        'getChannelUserDescriptors() has not been implemented.');
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

  Future<int?> setAllMessagesReadWithResult(Channel channel) async {
    return await MessagesMethods()
        .setAllMessagesReadWithResult(channel, _chatClient);
  }

  @override
  Future<dynamic> getMessagesAfter(
      int index, int count, Channel channel) async {
    return await MessagesMethods()
        .getMessagesDirection(index, count, channel, _chatClient, "forward");
  }

  @override
  Future<dynamic> getMessagesBefore(
      int index, int count, Channel channel) async {
    return await MessagesMethods()
        .getMessagesDirection(index, count, channel, _chatClient, "backwards");
  }

  @override
  Future<dynamic> getMessageByIndex(Channel channel, int messageIndex) async {
    throw UnimplementedError('getMessageByIndex() has not been implemented');
  }

  @override
  Future<dynamic> getLastMessages(int count, Channel channel) async {
    return await MessagesMethods().getLastMessages(count, channel, _chatClient);
  }

  @override
  Future<dynamic> sendMessage(MessageOptions options, Channel channel) async {
    return await MessagesMethods().sendMessage(options, channel, _chatClient);
  }

  @override
  Future<int> getUnreadMessagesCount(String channelSid) async {
    return await ChannelMethods()
        .getUnreadMessagesCount(channelSid, _chatClient);
  }

  Future<String> updateMessageBody(
      String? channelSid, int? messageIndex, String body) async {
    throw UnimplementedError('updateMessageBody() has not been implemented');
  }

  Future<dynamic> setAttributes(String? channelSid, int? messageIndex,
      Map<String, dynamic> attributes) async {
    throw UnimplementedError('setAttributes() has not been implemented');
  }

  @override
  Future<void> typingChannel(String channelSid) async {
    return await ChannelMethods().typing(channelSid, _chatClient);
  }

  @override
  Future<int> getMessagesCount(String channelSid) async {
    return await ChannelMethods().getMessagesCount(channelSid, _chatClient);
  }

  Future<int?> setLastReadMessageIndexWithResult(
      Channel channel, int lastReadMessageIndex) async {
    throw UnimplementedError(
        'setLastReadMessageIndexWithResult() has not been implemented');
  }

  Future<int?> advanceLastReadMessageIndexWithResult(
      Channel channel, int lastReadMessageIndex) async {
    throw UnimplementedError(
        'advanceLastReadMessageIndexWithResult() has not been implemented');
  }

  Future<int?> setNoMessagesReadWithResult(Channel channel) async {
    throw UnimplementedError(
        'setNoMessagesReadWithResult() has not been implemented');
  }

  Future<void> removeMessage(Channel channel, Message message) async {
    throw UnimplementedError('removeMessage() has not been implemented');
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
  Future<void> joinChannel(String channelSid) {
    print('web event: joinChannel');
    // TODO: implement joinChannel
    throw UnimplementedError();
  }

  Future<String> getDownloadURL(String channelSid, int messageIndex) async {
    return await MessageMethods()
        .getMedia(channelSid, messageIndex, _chatClient!);
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

  Future<void> handleReceivedNotification() async {
    throw UnimplementedError(
        'handleReceivedNotification() has not been implemented');
  }

  Future<String> registerForNotification(String token) async {
    throw UnimplementedError(
        'registerForNotification() has not been implemented');
  }

  @override
  Future<String> setUniqueNameChannel(String channelSid, String uniqueName) {
    print('web event: setUniqueNameChannel');
    // TODO: implement setUniqueNameChannel
    throw UnimplementedError();
  }

  @override
  Future<dynamic> requestNextPage(String pageId, String itemType) async {
    throw UnimplementedError('requestNextPage() has not been implemented');
  }

  @override
  Stream<Map<String, dynamic>> chatClientStream() {
    print('TwilioConversationsPlugin.create => starting stream');
    return _chatClientStreamController.stream;
  }

  @override
  Stream<Map<String, dynamic>> channelStream(String channelSid) {
    print('TwilioConversationsPlugin.channel => starting stream');
    return channelListeners[channelSid]!.stream;
  }

  Future<void> platformDebug(bool dart, bool native, bool sdk) {
    throw UnimplementedError('debug() has not been implemented');
  }
}
