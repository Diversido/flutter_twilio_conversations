import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/listeners/chat_listener.dart';
import 'package:flutter_twilio_conversations_web/logging.dart';
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
  Future<dynamic> createChatClient(
      String token, Map<String, Object> properties) async {
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
      Logging.debug('error: createConversation ${e}');
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
    Logging.debug('createChannel() has not been implemented.');
    return {};
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) async {
    return await ChannelsMethods()
        .getChannel(channelSidOrUniqueName, _chatClient, this);
  }

  Future<dynamic> getPublicChannelsList() async {
    Logging.debug('getPublicChannelsList() has not been implemented.');
    return null;
  }

  Future<dynamic> getUserChannelsList() async {
    Logging.debug('getUserChannelsList() has not been implemented.');
    return null;
  }

  Future<void> unsubscribe(String? identity) async {
    Logging.debug('unsubscribe() has not been implemented.');
    return null;
  }

  Future<dynamic> getMembersByIdentity(String identity) async {
    Logging.debug('getMembersByIdentity() has not been implemented.');
    return null;
  }

  Future<dynamic> getMember(String channelSid, String identity) async {
    Logging.debug('getMember() has not been implemented');
    return null;
  }

  Future<dynamic> getMembersList(String channelSid) async {
    Logging.debug('getMembersList() has not been implemented');
    return null;
  }

  Future<bool?> addByIdentity(String channelSid, String identity) async {
    Logging.debug('addByIdentity() has not been implemented');
    return null;
  }

  Future<bool?> removeByIdentity(String channelSid, String identity) async {
    Logging.debug('removeByIdentity() has not been implemented');
    return null;
  }

  Future<bool?> inviteByIdentity(String channelSid, String identity) async {
    Logging.debug('inviteByIdentity() has not been implemented');
    return null;
  }

  Future<dynamic> setAttributesMember(
      String sid, String? channelSid, Map<String, dynamic> attributes) async {
    Logging.debug('setAttributesMember() has not been implemented');
    return null;
  }

  Future<dynamic> memberGetAndSubscribeUser(
      String? identity, String? sid) async {
    Logging.debug('memberGetAndSubscribeUser() has not been implemented');
    return null;
  }

  Future<dynamic> memberGetUserDescriptor(
      String? identity, String? channelSid) async {
    Logging.debug('memberGetUserDescriptor() has not been implemented');
  }

  Future<void> declineInvitationChannel(String channelSid) async {
    Logging.debug('declineInvitationChannel() has not been implemented');
    return null;
  }

  Future<dynamic> getAndSubscribeUser(String identity) async {
    Logging.debug('getAndSubscribeUser() has not been implemented.');
  }

  Future<dynamic> getUserDescriptor(String identity) async {
    Logging.debug('getUserDescriptor() has not been implemented.');
  }

  Future<dynamic> getChannelUserDescriptors(String channelSid) async {
    Logging.debug('getChannelUserDescriptors() has not been implemented.');
  }

  @override
  Future<void> destroyChannel(String channelSid) async {
    Logging.debug('destroyChannel() has not been implemented.');
  }

  @override
  Future<String> getFriendlyNameChannel(String channelSid) async {
    Logging.debug('getUniqueNameChannel() has not been implemented');
    return '';
  }

  Future<int?> setAllMessagesReadWithResult(String channelSid) async {
    return await MessagesMethods()
        .setAllMessagesReadWithResult(channelSid, _chatClient);
  }

  @override
  Future<dynamic> getMessagesAfter(
      int index, int count, String channelSid) async {
    return await MessagesMethods()
        .getMessagesDirection(index, count, channelSid, _chatClient, "forward");
  }

  @override
  Future<dynamic> getMessagesBefore(
      int index, int count, String channelSid) async {
    return await MessagesMethods().getMessagesDirection(
        index, count, channelSid, _chatClient, "backwards");
  }

  @override
  Future<dynamic> getMessageByIndex(String channelSid, int messageIndex) async {
    Logging.debug('getMessageByIndex() has not been implemented');
    return null;
  }

  @override
  Future<dynamic> getLastMessages(int count, String channelSid) async {
    return await MessagesMethods()
        .getLastMessages(count, channelSid, _chatClient);
  }

  @override
  Future<dynamic> sendMessage(
      Map<String, dynamic> messageOptions, String channelSid) async {
    return await MessagesMethods()
        .sendMessage(messageOptions, channelSid, _chatClient);
  }

  @override
  Future<int> getUnreadMessagesCount(String channelSid) async {
    return await ChannelMethods()
        .getUnreadMessagesCount(channelSid, _chatClient);
  }

  Future<String> updateMessageBody(
      String? channelSid, int? messageIndex, String body) async {
    Logging.debug('updateMessageBody() has not been implemented');
    return '';
  }

  Future<dynamic> setAttributes(String? channelSid, int? messageIndex,
      Map<String, dynamic> attributes) async {
    Logging.debug('setAttributes() has not been implemented');
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
      String channelSid, int lastReadMessageIndex) async {
    Logging.debug(
        'setLastReadMessageIndexWithResult() has not been implemented');
    return null;
  }

  Future<int?> advanceLastReadMessageIndexWithResult(
      String channelSid, int lastReadMessageIndex) async {
    Logging.debug(
        'advanceLastReadMessageIndexWithResult() has not been implemented');
    return null;
  }

  Future<int?> setNoMessagesReadWithResult(String channelSid) async {
    Logging.debug('setNoMessagesReadWithResult() has not been implemented');
    return null;
  }

  Future<void> removeMessage(String channelSid, int messageIndex) async {
    Logging.debug('removeMessage() has not been implemented');
    return null;
  }

  @override
  Future<String> getNotificationLevelChannel(String channelSid) async {
    Logging.debug('getNotificationLevelChannel() has not been implemented');
    return '';
  }

  @override
  Future<String> getUniqueNameChannel(String channelSid) async {
    Logging.debug('getUniqueNameChannel() has not been implemented');
    return '';
  }

  @override
  Future<void> joinChannel(String channelSid) async {
    Logging.debug('joinChannel() has not been implemented');
    return null;
  }

  Future<String> getDownloadURL(String channelSid, int messageIndex) async {
    return await MessageMethods()
        .getMedia(channelSid, messageIndex, _chatClient!);
  }

  @override
  Future<void> leaveChannel(String channelSid) async {
    Logging.debug('leaveChannel() has not been implemented');
    return null;
  }

  @override
  Future<Map<String, dynamic>> setAttributesChannel(
      String channelSid, Map<String, dynamic> attributes) async {
    Logging.debug('setAttributesChannel() has not been implemented');
    return {};
  }

  @override
  Future<String> setFriendlyNameChannel(
      String channelSid, String friendlyName) async {
    Logging.debug('setFriendlyNameChannel() has not been implemented');
    return '';
  }

  @override
  Future<String> setNotificationLevelChannel(
      String channelSid, String notificationLevel) async {
    Logging.debug('setNotificationLevelChannel() has not been implemented');
    return '';
  }

  Future<void> handleReceivedNotification() async {
    Logging.debug('handleReceivedNotification() has not been implemented');
    return null;
  }

  Future<String> registerForNotification(String token) async {
    Logging.debug('registerForNotification() has not been implemented');
    return '';
  }

  Future<void> unregisterForNotification(String token) async {
    Logging.debug('unregisterForNotification() has not been implemented');
    return null;
  }

  @override
  Future<String> setUniqueNameChannel(
      String channelSid, String uniqueName) async {
    Logging.debug('setUniqueNameChannel() has not been implemented');
    return '';
  }

  @override
  Future<dynamic> requestNextPage(String pageId, String itemType) async {
    Logging.debug('requestNextPage() has not been implemented');
    return null;
  }

  @override
  Stream<Map<String, dynamic>> chatClientStream() {
    Logging.debug(
      'TwilioConversationsPlugin.create => starting stream',
    );
    return _chatClientStreamController.stream;
  }

  @override
  Stream<Map<String, dynamic>> channelStream(String channelSid) {
    Logging.debug(
      'TwilioConversationsPlugin.channel => starting stream',
    );
    return channelListeners[channelSid]!.stream;
  }

  Future<void> platformDebug(bool dart, bool native, bool sdk) async {
    Logging.debug('getUniqueNameChannel() has not been implemented');
    return null;
  }

  @override
  Stream<Map<dynamic, dynamic>>? notificationStream() {
    Logging.debug(
      'notificationStream() has not been implemented',
    );
    return Stream.empty();
  }
}
