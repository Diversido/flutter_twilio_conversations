import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:meta/meta.dart';
import '../platform_interface/flutter_twilio_conversations_platform.dart';

// const MethodChannel _channel =
//     MethodChannel('plugins.flutter.io/flutter_twilio_conversations');

/// An implementation of [FlutterTwilioConversationsPlatform] that uses method channels.
class MethodChannelFlutterTwilioConversations
    extends FlutterTwilioConversationsPlatform {
  // @visibleForTesting
  // MethodChannel get channel => _channel;
  final MethodChannel _methodChannel;
  final EventChannel _chatChannel;

  MethodChannelFlutterTwilioConversations()
      : _methodChannel = MethodChannel('flutter_twilio_conversations'),
        _chatChannel = EventChannel('flutter_twilio_conversations/room'),
        super();

  /// This constructor is only used for testing and shouldn't be accessed by
  /// users of the plugin. It may break or change at any time.
  @visibleForTesting
  MethodChannelFlutterTwilioConversations.private(
    this._methodChannel,
    this._chatChannel,
  );

  @override
  Future<dynamic> create(String token, Properties properties) async {
    return _methodChannel.invokeMethod('create',
        <String, Object>{'token': token, 'properties': properties.toMap()});
  }

  @override
  Future<void> updateToken(String token) async {
    return await _methodChannel.invokeMethod(
        'ChatClient#updateToken', <String, Object>{'token': token});
  }

  @override
  Future<void> shutdown() async {
    return await _methodChannel.invokeMethod('ChatClient#shutdown', null);
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) async {
    return await _methodChannel.invokeMethod(
        'Channels#createChannel', <String, Object>{
      'friendlyName': friendlyName,
      'channelType': channelType
    });
  }

  Future<dynamic> getChannelUserDescriptors(String channelSid) async {
    return await _methodChannel.invokeMethod(
        'Users#getChannelUserDescriptors', {'channelSid': channelSid});
  }

  Future<UserDescriptor?> getUserDescriptor(String identity) async {
    return await _methodChannel
        .invokeMethod('Users#getUserDescriptor', {'identity': identity});
  }

  Future<void> unsubscribe(String? _identity) async {
    await _methodChannel
        .invokeMethod('User#unsubscribe', {'identity': _identity});
  }

  Future<dynamic> getAndSubscribeUser(String identity) async {
    return await _methodChannel
        .invokeMethod('Users#getAndSubscribeUser', {'identity': identity});
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) async {
    return await _methodChannel.invokeMethod('Channels#getChannel',
        <String, Object>{'channelSidOrUniqueName': channelSidOrUniqueName});
  }

  Future<dynamic> getPublicChannelsList() async {
    return await _methodChannel.invokeMethod('Channels#getPublicChannelsList');
  }

  Future<dynamic> getUserChannelsList() async {
    return await _methodChannel.invokeMethod('Channels#getUserChannelsList');
  }

  Future<dynamic> getMembersByIdentity(String identity) async {
    return await _methodChannel
        .invokeMethod('Channels#getMembersByIdentity', {'identity': identity});
  }

  Future<dynamic> getMember(String _channelSid, String identity) async {
    return await _methodChannel.invokeMethod('Members#getMember', {
      'channelSid': _channelSid,
      'identity': identity,
    });
  }

  Future<dynamic> getMembersList(String _channelSid) async {
    return await _methodChannel.invokeMethod('Members#getMembersList', {
      'channelSid': _channelSid,
    });
  }

  Future<bool?> addByIdentity(String _channelSid, String identity) async {
    return _methodChannel.invokeMethod('Members#addByIdentity',
        {'identity': identity, 'channelSid': _channelSid});
  }

  Future<bool?> removeByIdentity(String _channelSid, String identity) async {
    return _methodChannel.invokeMethod('Members#removeByIdentity',
        {'identity': identity, 'channelSid': _channelSid});
  }

  Future<bool?> inviteByIdentity(String _channelSid, String identity) async {
    return _methodChannel.invokeMethod('Members#inviteByIdentity',
        {'identity': identity, 'channelSid': _channelSid});
  }

  Future<dynamic> setAttributesMember(
      String _sid, String? _channelSid, Map<String, dynamic> attributes) async {
    return _methodChannel.invokeMethod('Member#setAttributes', {
      'memberSid': _sid,
      'channelSid': _channelSid,
      'attributes': attributes
    });
  }

  Future<dynamic> memberGetUserDescriptor(
      String? _identity, String? _channelSid) async {
    return await _methodChannel.invokeMethod('Member#getUserDescriptor', {
      'identity': _identity,
      'channelSid': _channelSid,
    });
  }

  Future<dynamic> memberGetAndSubscribeUser(
      String? _sid, String? _channelSid) async {
    return await _methodChannel.invokeMethod('Member#getAndSubscribeUser', {
      'memberSid': _sid,
      'channelSid': _channelSid,
    });
  }

  @override
  Future<void> declineInvitationChannel(String channelSid) {
    return _methodChannel
        .invokeMethod('Channel#declineInvitation', {'channelSid': channelSid});
  }

  @override
  Future<void> destroyChannel(String channelSid) {
    return _methodChannel
        .invokeMethod('Channel#destroy', {'channelSid': channelSid});
  }

  @override
  Future<String> getFriendlyNameChannel(String channelSid) async {
    return await _methodChannel
        .invokeMethod('Channel#getFriendlyName', {'channelSid': channelSid});
  }

  @override
  Future<int> getMembersCountChannel(String channelSid) async {
    return await _methodChannel
        .invokeMethod('Channel#getMembersCount', {'channelSid': channelSid});
  }

  @override
  Future<int> getMessagesCount(String channelSid) async {
    return await _methodChannel
        .invokeMethod('Channel#getMessagesCount', {'channelSid': channelSid});
  }

  @override
  Future<String> getNotificationLevelChannel(String channelSid) async {
    return await _methodChannel.invokeMethod(
        'Channel#getNotificationLevel', {'channelSid': channelSid});
  }

  @override
  Future<String> getUniqueNameChannel(String channelSid) async {
    return await _methodChannel
        .invokeMethod('Channel#getUniqueName', {'channelSid': channelSid});
  }

  Future<void> removeMessage(Channel _channel, Message message) async {
    await _methodChannel.invokeMethod('Messages#removeMessage',
        {'channelSid': _channel.sid, 'messageIndex': message.messageIndex});
  }

  @override
  Future<int> getUnreadMessagesCount(String channelSid) async {
    return await _methodChannel.invokeMethod(
        'Channel#getUnreadMessagesCount', {'channelSid': channelSid});
  }

  @override
  Future<int?> setLastReadMessageIndexWithResult(
      Channel _channel, int lastReadMessageIndex) async {
    return await _methodChannel.invokeMethod(
        'Messages#setLastReadMessageIndexWithResult', {
      'channelSid': _channel.sid,
      'lastReadMessageIndex': lastReadMessageIndex
    });
  }

  @override
  Future<int?> advanceLastReadMessageIndexWithResult(
      Channel _channel, int lastReadMessageIndex) async {
    return await _methodChannel.invokeMethod(
        'Messages#advanceLastReadMessageIndexWithResult', {
      'channelSid': _channel.sid,
      'lastReadMessageIndex': lastReadMessageIndex
    });
  }

  Future<int?> setNoMessagesReadWithResult(Channel _channel) async {
    return _methodChannel.invokeMethod(
        'Messages#setNoMessagesReadWithResult', {'channelSid': _channel.sid});
  }

  @override
  Future<void> joinChannel(String channelSid) {
    return _methodChannel
        .invokeMethod('Channel#join', {'channelSid': channelSid});
  }

  @override
  Future<void> leaveChannel(String channelSid) {
    return _methodChannel
        .invokeMethod('Channel#leave', {'channelSid': channelSid});
  }

  @override
  Future<Map<String, dynamic>> setAttributesChannel(
      String channelSid, Map<String, dynamic> attributes) async {
    return await _methodChannel.invokeMethod('Channel#setAttributes',
        {'channelSid': channelSid, 'attributes': attributes});
  }

  @override
  Future<String> setFriendlyNameChannel(
      String channelSid, String friendlyName) async {
    return await _methodChannel.invokeMethod('Channel#setFriendlyName',
        {'channelSid': channelSid, 'friendlyName': friendlyName});
  }

  @override
  Future<String> setNotificationLevelChannel(
      String channelSid, String notificationLevel) async {
    return await _methodChannel.invokeMethod('Channel#setNotificationLevel', {
      'channelSid': channelSid,
      'notificationLevel': notificationLevel,
    });
  }

  @override
  Future<String> setUniqueNameChannel(
      String channelSid, String uniqueName) async {
    return await _methodChannel.invokeMethod('Channel#setUniqueName',
        {'channelSid': channelSid, 'uniqueName': uniqueName});
  }

  @override
  Future<void> typingChannel(String channelSid) {
    return _methodChannel
        .invokeMethod('Channel#typing', {'channelSid': channelSid});
  }

  @override
  Future<String> updateMessageBody(
      String? _channelSid, int? _messageIndex, String body) async {
    return await _methodChannel.invokeMethod('Message#updateMessageBody', {
          'channelSid': _channelSid,
          'messageIndex': _messageIndex,
          'body': body,
        }) ??
        '';
  }

  Future<dynamic> setAttributes(String? _channelSid, int? _messageIndex,
      Map<String, dynamic> attributes) async {
    return await _methodChannel.invokeMethod('Message#setAttributes', {
      'channelSid': _channelSid,
      'messageIndex': _messageIndex,
      'attributes': attributes,
    });
  }

  Future<String> getDownloadURL(String _channelSid, int _messageIndex) async {
    return await _methodChannel.invokeMethod('Message#getMedia', {
      'channelSid': _channelSid,
      'messageIndex': _messageIndex,
    });
  }

  Future<dynamic> requestNextPage(String _pageId, String _itemType) async {
    return await _methodChannel.invokeMethod('Paginator#requestNextPage',
        <String, Object>{'pageId': _pageId, 'itemType': _itemType});
  }

  @override
  Future<dynamic> getMessageByIndex(Channel _channel, int messageIndex) async {
    return await _methodChannel.invokeMethod('Messages#getMessageByIndex',
        {'channelSid': _channel.sid, 'messageIndex': messageIndex});
  }

  @override
  Future<dynamic> getLastMessages(int count, Channel _channel) async {
    return await _methodChannel.invokeMethod('Messages#getLastMessages', {
      'count': count,
      'channelSid': _channel.sid,
    });
  }

  @override
  Future<dynamic> getMessagesAfter(
      int index, int count, Channel _channel) async {
    return await _methodChannel.invokeMethod('Messages#getMessagesAfter', {
      'index': index,
      'count': count,
      'channelSid': _channel.sid,
    });
  }

  @override
  Future<dynamic> getMessagesBefore(
      int index, int count, Channel _channel) async {
    return await _methodChannel.invokeMethod('Messages#getMessagesBefore', {
      'index': index,
      'count': count,
      'channelSid': _channel.sid,
    });
  }

  Future<int?> setAllMessagesReadWithResult(Channel _channel) async {
    return await _methodChannel.invokeMethod(
        'Messages#setAllMessagesReadWithResult', {'channelSid': _channel.sid});
  }

  @override
  Future<dynamic> sendMessage(MessageOptions options, Channel _channel) async {
    return await _methodChannel.invokeMethod('Messages#sendMessage', {
      'options': options.toMap(),
      'channelSid': _channel.sid,
    });
  }

  @override
  Future<void> platformDebug(bool dart, bool native, bool sdk) async {
    return await _methodChannel
        .invokeMethod('debug', {'native': native, 'sdk': sdk});
  }

// needs to be implemented for the mobile interface
  Stream<Map<dynamic, dynamic>>? chatClientStream() {
    try {
      return _chatChannel.receiveBroadcastStream().map((event) {
        return event as Map<dynamic, dynamic>;
      });
    } catch (e) {
      print('chatClientStream error: $e');
      return null;
    }
  }

  Stream<Map<dynamic, dynamic>>? channelStream(String sid) {
    try {
      return EventChannel('flutter_twilio_conversations/$sid')
          .receiveBroadcastStream()
          .map((event) {
        return event as Map<dynamic, dynamic>;
      });
    } catch (e) {
      print('chatClientStream error: $e');
      return null;
    }
  }
}
