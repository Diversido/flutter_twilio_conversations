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
    // TODO Nic check that properties can be dynamic
    return _methodChannel.invokeMethod('create',
        <String, Object>{'token': token, 'properties': properties.toMap()});
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) async {
    return await _methodChannel.invokeMethod(
        'Channels#createChannel', <String, Object>{
      'friendlyName': friendlyName,
      'channelType': channelType
    });
  }

// TODO Nic see if dynamic doesn't need to be returned
  Future<dynamic> getChannel(String channelSidOrUniqueName) {
    return _methodChannel.invokeMethod('Channels#getChannel',
        <String, Object>{'channelSidOrUniqueName': channelSidOrUniqueName});
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
  Future<int> getMessagesCountChannel(String channelSid) async {
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

  @override
  Future<int> getUnreadMessagesCountChannel(String channelSid) async {
    return await _methodChannel.invokeMethod(
        'Channel#getUnreadMessagesCount', {'channelSid': channelSid});
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
  Future<dynamic> getLastMessages(int count, Channel _channel) async {
    return await _methodChannel.invokeMethod('Messages#getLastMessages', {
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
