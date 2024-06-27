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

  Future<dynamic> createChatClient(String token, Properties properties) {
    throw UnimplementedError('create() has not been implemented.');
  }

  Future<void> updateToken(String token) async {
    throw UnimplementedError('updateToken() has not been implemented.');
  }

  Future<void> shutdown() async {
    throw UnimplementedError('shutdown() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> createChannel(
      String friendlyName, String channelType) {
    throw UnimplementedError('createChannel() has not been implemented.');
  }

  Future<dynamic> getChannel(String channelSidOrUniqueName) {
    throw UnimplementedError('getChannel() has not been implemented.');
  }

  Future<dynamic> getPublicChannelsList() async {
    throw UnimplementedError(
        'getPublicChannelsList() has not been implemented.');
  }

  Future<dynamic> getUserChannelsList() async {
    throw UnimplementedError('getUserChannelsList() has not been implemented.');
  }

  Future<dynamic> getUserDescriptor(String identity) async {
    throw UnimplementedError('getUserDescriptor() has not been implemented.');
  }

  Future<dynamic> getChannelUserDescriptors(String channelSid) async {
    throw UnimplementedError(
        'getChannelUserDescriptors() has not been implemented.');
  }

  Future<dynamic> getAndSubscribeUser(String identity) async {
    throw UnimplementedError('getAndSubscribeUser() has not been implemented.');
  }

  Future<void> unsubscribe(String? identity) async {
    throw UnimplementedError('unsubscribe() has not been implemented.');
  }

  Future<dynamic> getMembersByIdentity(String identity) async {
    throw UnimplementedError(
        'getMembersByIdentity() has not been implemented.');
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

  Future<dynamic> memberGetUserDescriptor(
      String? identity, String? channelSid) async {
    throw UnimplementedError(
        'memberGetUserDescriptor() has not been implemented');
  }

  Future<dynamic> memberGetAndSubscribeUser(
      String? identity, String? sid) async {
    throw UnimplementedError(
        'memberGetAndSubscribeUser() has not been implemented');
  }

  Future<int> getMessagesCount(String channelSid) {
    throw UnimplementedError('getMessagesCount() has not been implemented');
  }

  Future<String> updateMessageBody(
      String? channelSid, int? messageIndex, String body) async {
    throw UnimplementedError('updateMessageBody() has not been implemented');
  }

  Future<dynamic> setAttributes(String? channelSid, int? messageIndex,
      Map<String, dynamic> attributes) async {
    throw UnimplementedError('setAttributes() has not been implemented');
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

  Future<void> removeMessage(Channel channel, Message message) async {
    throw UnimplementedError('removeMessage() has not been implemented');
  }

  Future<int?> setNoMessagesReadWithResult(Channel channel) async {
    throw UnimplementedError(
        'setNoMessagesReadWithResult() has not been implemented');
  }

  Future<String> getNotificationLevelChannel(String channelSid) {
    throw UnimplementedError(
        'getNotificationLevelChannel() has not been implemented');
  }

  Future<String> getUniqueNameChannel(String channelSid) {
    throw UnimplementedError('getUniqueNameChannel() has not been implemented');
  }

  Future<int?> getUnreadMessagesCount(String channelSid) {
    throw UnimplementedError(
        'getUnreadMessagesCount() has not been implemented');
  }

  Future<String> getDownloadURL(String channelSid, int messageIndex) async {
    throw UnimplementedError('getDownloadURL() has not been implemented');
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

  Future<void> handleReceivedNotification() async {
    throw UnimplementedError(
        'handleReceivedNotification() has not been implemented');
  }

  Future<String> registerForNotification(String token) async {
    throw UnimplementedError(
        'registerForNotification() has not been implemented');
  }

  Future<void> unregisterForNotification(String token) async {
    throw UnimplementedError(
        'unregisterForNotification() has not been implemented');
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

  Future<int?> setAllMessagesReadWithResult(Channel channel) async {
    throw UnimplementedError(
        'setAllMessagesReadWithResult() has not been implemented');
  }

  Future<dynamic> getMessageByIndex(Channel channel, int messageIndex) async {
    throw UnimplementedError('getMessageByIndex() has not been implemented');
  }

  Future<dynamic> getLastMessages(int count, Channel channel) async {
    throw UnimplementedError('getLastMessages() has not been implemented');
  }

  Future<dynamic> getMessagesAfter(
      int index, int count, Channel channel) async {
    throw UnimplementedError('getMessagesAfter() has not been implemented');
  }

  Future<dynamic> getMessagesBefore(
      int index, int count, Channel channel) async {
    throw UnimplementedError('getMessagesBefore() has not been implemented');
  }

  Future<dynamic> sendMessage(MessageOptions options, Channel channel) async {
    throw UnimplementedError('sendMessage() has not been implemented');
  }

  Future<dynamic> requestNextPage(String pageId, String itemType) async {
    throw UnimplementedError('requestNextPage() has not been implemented');
  }

  /// This stream is used to update the ChatClient in a plugin implementation.
  Stream<Map<dynamic, dynamic>>? chatClientStream() {
    throw UnimplementedError('chatClientStream() has not been implemented');
  }

  /// This stream is used to update the Channel in a plugin implementation.
  Stream<Map<dynamic, dynamic>>? channelStream(String sid) {
    throw UnimplementedError('channelStream() has not been implemented');
  }

  /// This stream is used to update the Notification in a plugin implementation.
  Stream<Map<dynamic, dynamic>>? notificationStream() {
    throw UnimplementedError('notificationStream() has not been implemented');
  }
}
