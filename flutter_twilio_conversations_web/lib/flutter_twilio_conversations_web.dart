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
      TwilioConversationsClient.log('error: createConversation ${e}');
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
    TwilioConversationsClient.log('createChannel() has not been implemented.');
    return {};
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) async {
    return await ChannelsMethods()
        .getChannel(channelSidOrUniqueName, _chatClient, this);
  }

  Future<dynamic> getPublicChannelsList() async {
    TwilioConversationsClient.log(
        'getPublicChannelsList() has not been implemented.');
    return null;
  }

  Future<dynamic> getUserChannelsList() async {
    TwilioConversationsClient.log(
        'getUserChannelsList() has not been implemented.');
    return null;
  }

  Future<void> unsubscribe(String? identity) async {
    TwilioConversationsClient.log('unsubscribe() has not been implemented.');
    return null;
  }

  Future<dynamic> getMembersByIdentity(String identity) async {
    TwilioConversationsClient.log(
        'getMembersByIdentity() has not been implemented.');
    return null;
  }

  Future<dynamic> getMember(String channelSid, String identity) async {
    TwilioConversationsClient.log('getMember() has not been implemented');
    return null;
  }

  Future<dynamic> getMembersList(String channelSid) async {
    TwilioConversationsClient.log('getMembersList() has not been implemented');
    return null;
  }

  Future<bool?> addByIdentity(String channelSid, String identity) async {
    TwilioConversationsClient.log('addByIdentity() has not been implemented');
    return null;
  }

  Future<bool?> removeByIdentity(String channelSid, String identity) async {
    TwilioConversationsClient.log(
        'removeByIdentity() has not been implemented');
    return null;
  }

  Future<bool?> inviteByIdentity(String channelSid, String identity) async {
    TwilioConversationsClient.log(
        'inviteByIdentity() has not been implemented');
    return null;
  }

  Future<dynamic> setAttributesMember(
      String sid, String? channelSid, Map<String, dynamic> attributes) async {
    TwilioConversationsClient.log(
        'setAttributesMember() has not been implemented');
    return null;
  }

  Future<dynamic> memberGetAndSubscribeUser(
      String? identity, String? sid) async {
    TwilioConversationsClient.log(
        'memberGetAndSubscribeUser() has not been implemented');
    return null;
  }

  Future<dynamic> memberGetUserDescriptor(
      String? identity, String? channelSid) async {
    TwilioConversationsClient.log(
        'memberGetUserDescriptor() has not been implemented');
  }

  Future<void> declineInvitationChannel(String channelSid) async {
    TwilioConversationsClient.log(
        'declineInvitationChannel() has not been implemented');
    return null;
  }

  Future<dynamic> getAndSubscribeUser(String identity) async {
    TwilioConversationsClient.log(
        'getAndSubscribeUser() has not been implemented.');
  }

  Future<dynamic> getUserDescriptor(String identity) async {
    TwilioConversationsClient.log(
        'getUserDescriptor() has not been implemented.');
  }

  Future<dynamic> getChannelUserDescriptors(String channelSid) async {
    TwilioConversationsClient.log(
        'getChannelUserDescriptors() has not been implemented.');
  }

  @override
  Future<void> destroyChannel(String channelSid) async {
    TwilioConversationsClient.log('destroyChannel() has not been implemented.');
  }

  @override
  Future<String> getFriendlyNameChannel(String channelSid) async {
    TwilioConversationsClient.log(
        'getUniqueNameChannel() has not been implemented');
    return '';
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
    TwilioConversationsClient.log(
        'getMessageByIndex() has not been implemented');
    return null;
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
    TwilioConversationsClient.log(
        'updateMessageBody() has not been implemented');
    return '';
  }

  Future<dynamic> setAttributes(String? channelSid, int? messageIndex,
      Map<String, dynamic> attributes) async {
    TwilioConversationsClient.log('setAttributes() has not been implemented');
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
    TwilioConversationsClient.log(
        'setLastReadMessageIndexWithResult() has not been implemented');
    return null;
  }

  Future<int?> advanceLastReadMessageIndexWithResult(
      Channel channel, int lastReadMessageIndex) async {
    TwilioConversationsClient.log(
        'advanceLastReadMessageIndexWithResult() has not been implemented');
    return null;
  }

  Future<int?> setNoMessagesReadWithResult(Channel channel) async {
    TwilioConversationsClient.log(
        'setNoMessagesReadWithResult() has not been implemented');
    return null;
  }

  Future<void> removeMessage(Channel channel, Message message) async {
    TwilioConversationsClient.log('removeMessage() has not been implemented');
    return null;
  }

  @override
  Future<String> getNotificationLevelChannel(String channelSid) async {
    TwilioConversationsClient.log(
        'getNotificationLevelChannel() has not been implemented');
    return '';
  }

  @override
  Future<String> getUniqueNameChannel(String channelSid) async {
    TwilioConversationsClient.log(
        'getUniqueNameChannel() has not been implemented');
    return '';
  }

  @override
  Future<void> joinChannel(String channelSid) async {
    TwilioConversationsClient.log('joinChannel() has not been implemented');
    return null;
  }

  Future<String> getDownloadURL(String channelSid, int messageIndex) async {
    return await MessageMethods()
        .getMedia(channelSid, messageIndex, _chatClient!);
  }

  @override
  Future<void> leaveChannel(String channelSid) async {
    TwilioConversationsClient.log('leaveChannel() has not been implemented');
    return null;
  }

  @override
  Future<Map<String, dynamic>> setAttributesChannel(
      String channelSid, Map<String, dynamic> attributes) async {
    TwilioConversationsClient.log(
        'setAttributesChannel() has not been implemented');
    return {};
  }

  @override
  Future<String> setFriendlyNameChannel(
      String channelSid, String friendlyName) async {
    TwilioConversationsClient.log(
        'setFriendlyNameChannel() has not been implemented');
    return '';
  }

  @override
  Future<String> setNotificationLevelChannel(
      String channelSid, String notificationLevel) async {
    TwilioConversationsClient.log(
        'setNotificationLevelChannel() has not been implemented');
    return '';
  }

  Future<void> handleReceivedNotification() async {
    TwilioConversationsClient.log(
        'handleReceivedNotification() has not been implemented');
    return null;
  }

  Future<String> registerForNotification(String token) async {
    TwilioConversationsClient.log(
        'registerForNotification() has not been implemented');
    return '';
  }

  Future<void> unregisterForNotification(String token) async {
    TwilioConversationsClient.log(
        'unregisterForNotification() has not been implemented');
    return null;
  }

  @override
  Future<String> setUniqueNameChannel(
      String channelSid, String uniqueName) async {
    TwilioConversationsClient.log(
        'setUniqueNameChannel() has not been implemented');
    return '';
  }

  @override
  Future<dynamic> requestNextPage(String pageId, String itemType) async {
    TwilioConversationsClient.log('requestNextPage() has not been implemented');
    return null;
  }

  @override
  Stream<Map<String, dynamic>> chatClientStream() {
    TwilioConversationsClient.log(
      'TwilioConversationsPlugin.create => starting stream',
    );
    return _chatClientStreamController.stream;
  }

  @override
  Stream<Map<String, dynamic>> channelStream(String channelSid) {
    TwilioConversationsClient.log(
      'TwilioConversationsPlugin.channel => starting stream',
    );
    return channelListeners[channelSid]!.stream;
  }

  Future<void> platformDebug(bool dart, bool native, bool sdk) async {
    TwilioConversationsClient.log(
        'getUniqueNameChannel() has not been implemented');
    return null;
  }

  @override
  Stream<Map<dynamic, dynamic>>? notificationStream() {
    TwilioConversationsClient.log(
      'notificationStream() has not been implemented',
    );
    return Stream.empty();
  }
}
