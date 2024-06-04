// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../method_channel/method_channel_flutter_twilio_conversations.dart';

/// The interface that implementations of flutter_twilio_conversations must implement.
///
/// Platform implementations that live in a separate package should extend this
/// class rather than implement it as `flutter_twilio_conversations` does not consider newly
/// added methods to be breaking changes. Extending this class (using `extends`)
/// ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by
/// newly added [FlutterTwilioConversationsPlatform] methods.
abstract class FlutterTwilioConversationsPlatform extends PlatformInterface {
  FlutterTwilioConversationsPlatform() : super(token: _token);

  static final Object _token = Object();

  /// The default instance of [FlutterTwilioConversationsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTwilioConversations].
  static FlutterTwilioConversationsPlatform _instance =
      MethodChannelFlutterTwilioConversations();

  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [FlutterTwilioConversationsPlatform] when they
  /// register themselves.

  static FlutterTwilioConversationsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterTwilioConversationsPlatform] when they register themselves.
  static set instance(FlutterTwilioConversationsPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<dynamic> create(String token, Properties properties) {
    throw UnimplementedError('create() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) {
    throw UnimplementedError('createChannel() has not been implemented.');
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) {
    throw UnimplementedError('getChannel() has not been implemented.');
  }

  Future<void> declineInvitationChannel(String channelSid) {
    throw UnimplementedError(
        'declineInvitationChannel() has not been implemented');
  }

  Future<void> destroyChannel(String channelSid) {
    throw UnimplementedError('destroyChannel() has not been implemented');
  }

  Future<String> getFriendlyNameChannel(String channelSid) {
    throw UnimplementedError(
        'getFriendlyNameChannel() has not been implemented');
  }

  Future<int> getMembersCountChannel(String channelSid) {
    throw UnimplementedError(
        'getMembersCountChannel() has not been implemented');
  }

  Future<int> getMessagesCountChannel(String channelSid) {
    throw UnimplementedError(
        'getMessagesCountChannel() has not been implemented');
  }

  Future<String> getNotificationLevelChannel(String channelSid) {
    throw UnimplementedError(
        'getNotificationLevelChannel() has not been implemented');
  }

  Future<String> getUniqueNameChannel(String channelSid) {
    throw UnimplementedError('getUniqueNameChannel() has not been implemented');
  }

  Future<int> getUnreadMessagesCountChannel(String channelSid) {
    throw UnimplementedError(
        'getUnreadMessagesCountChannel() has not been implemented');
  }

  Future<void> joinChannel(String channelSid) {
    throw UnimplementedError('joinChannel() has not been implemented');
  }

  Future<void> leaveChannel(String channelSid) {
    throw UnimplementedError('leaveChannel() has not been implemented');
  }

  Future<Map<String, dynamic>> setAttributesChannel(
      String channelSid, Map<String, dynamic> attributes) {
    throw UnimplementedError('setAttributesChannel() has not been implemented');
  }

  Future<String> setFriendlyNameChannel(
      String channelSid, String friendlyName) {
    throw UnimplementedError(
        'setFriendlyNameChannel() has not been implemented');
  }

  Future<String> setNotificationLevelChannel(
      String channelSid, String notificationLevel) {
    throw UnimplementedError(
        'setNotificationLevelChannel() has not been implemented');
  }

  Future<String> setUniqueNameChannel(String channelSid, String uniqueName) {
    throw UnimplementedError('setUniqueNameChannel() has not been implemented');
  }

  Future<void> typingChannel(String channelSid) {
    throw UnimplementedError('typingChannel() has not been implemented');
  }

  Future<void> platformDebug(bool dart, bool native, bool sdk) {
    throw UnimplementedError('platformDebug() has not been implemented');
  }

  Future<dynamic> getLastMessages(int count, Channel _channel) async {
    throw UnimplementedError('getLastMessages() has not been implemented');
  }

  @override
  Future<dynamic> sendMessage(MessageOptions options, Channel _channel) async {
    throw UnimplementedError('sendMessage() has not been implemented');
  }

  /// This stream is used to update the ChatClient in a plugin implementation.
  Stream<Map<dynamic, dynamic>>? chatClientStream() {
    throw UnimplementedError('chatClientStream() has not been implemented');
  }

  /// This stream is used to update the Channel in a plugin implementation.
  Stream<Map<String, dynamic>>? channelStream(String channel) {
    throw UnimplementedError('chatClientStream() has not been implemented');
  }
}
