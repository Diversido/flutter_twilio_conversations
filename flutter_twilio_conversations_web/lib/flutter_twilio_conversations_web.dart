import 'dart:async';
import 'dart:js_util';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioWebClient;
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message.dart';
import 'package:flutter_twilio_conversations_web/listeners/chat_listener.dart';
import 'package:flutter_twilio_conversations_web/mapper.dart';
import 'package:flutter_twilio_conversations_web/methods/channel_methods.dart';
import 'package:flutter_twilio_conversations_web/methods/channels_methods.dart';
import 'package:flutter_twilio_conversations_web/methods/messages_methods.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'listeners/channel_listener.dart';

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

  Future<void> updateToken(String token) async {
    _chatClient =
        await promiseToFuture<TwilioWebClient.TwilioConversationsClient>(
            _chatClient!.updateToken(token));
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) async {
    throw UnimplementedError('createChannel() has not been implemented.');
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) async {
    return await ChannelsMethods()
        .getChannel(channelSidOrUniqueName, _chatClient);
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

  Future<int?> setAllMessagesReadWithResult(Channel _channel) async {
    return await MessagesMethods()
        .setAllMessagesReadWithResult(_channel, _chatClient);
  }

  @override
  Future<dynamic> getMessagesAfter(
      int index, int count, Channel _channel) async {
    return await MessagesMethods()
        .getMessagesDirection(index, count, _channel, _chatClient, "forward");
  }

  @override
  Future<dynamic> getMessagesBefore(
      int index, int count, Channel _channel) async {
    return await MessagesMethods()
        .getMessagesDirection(index, count, _channel, _chatClient, "backwards");
  }

  @override
  Future<dynamic> getLastMessages(int count, Channel _channel) async {
    return await MessagesMethods()
        .getLastMessages(count, _channel, _chatClient);
  }

  @override
  Future<dynamic> sendMessage(MessageOptions options, Channel _channel) async {
    return await MessagesMethods().sendMessage(options, _channel, _chatClient);
  }

  @override
  Future<int> getUnreadMessagesCount(String channelSid) async {
    return await ChannelMethods()
        .getUnreadMessagesCount(channelSid, _chatClient);
  }

  @override
  Future<void> typingChannel(String channelSid) async {
    return await ChannelMethods().typing(channelSid, _chatClient);
  }

  @override
  Future<int> getMessagesCount(String channelSid) async {
    return await ChannelMethods().getMessagesCount(channelSid, _chatClient);
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

/*
___ChannelMethods___
getMembersCount
setAttributes
getFriendlyName
setFriendlyName
getNotificationLevel
setNotificationLevel
getUniqueName
setUniqueName
join
leave
typing
destroy
getMessagesCount
getUnreadMessagesCount
___ChannelsMethods___
getChannel
getPublicChannelsList
getUserChannelsList
createChannel
___ChatClientMethods__
updateToken
shutdown
___MemberMethods__
getChannel
getUserDescriptor
getAndSubscribeUser
setAttributes
___MembersMethods__
getChannel
getMembersList
getMember
addByIdentity
inviteByIdentity
removeByIdentity
MessageMethods__
getChannel
updateMessageBody
setAttributes
getMedia
MessagesMethods___
removeMessage
getMessagesBefore
getMessagesAfter
getLastMessages
getMessageByIndex
setLastReadMessageIndexWithResult
advanceLastReadMessageIndexWithResult
setAllMessagesReadWithResult
setNoMessagesReadWithResult
Users__
unsubscribe
Users__
getChannelUserDescriptors
getUserDescriptor
getAndSubscribeUser
*/