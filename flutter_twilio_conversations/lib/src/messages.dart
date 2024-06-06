part of flutter_twilio_conversations;

class Messages {
  final Channel _channel;

  //#region Private API properties
  int? _lastReadMessageIndex;
  //#endregion

  //#region Public API properties
  /// Return user last read message index for the channel.
  int? get lastReadMessageIndex {
    return _lastReadMessageIndex;
  }
  //#endregion

  Messages(this._channel);

  //#region Public API methods
  /// Sends a message to the channel.
  Future<Message?> sendMessage(MessageOptions options) async {
    try {
      final methodData = await FlutterTwilioConversationsPlatform.instance
          .sendMessage(options, _channel);
      final messageMap = Map<String, dynamic>.from(methodData);
      return Message._fromMap(messageMap, this);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Removes a message from the channel.
  Future<void> removeMessage(Message message) async {
    try {
      // await TwilioConversationsClient._methodChannel.invokeMethod(
      //     'Messages#removeMessage',
      //     {'channelSid': _channel.sid, 'messageIndex': message.messageIndex});
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Fetch at most count messages including and prior to the specified index.
  Future<List<Message>> getMessagesBefore(int index, int count) async {
    try {
      // final methodData = await TwilioConversationsClient._methodChannel
      //     .invokeMethod('Messages#getMessagesBefore', {
      //   'index': index,
      //   'count': count,
      //   'channelSid': _channel.sid,
      // });
      // final List<Map<String, dynamic>> messageMapList = methodData
      //     .map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r))
      //     .toList();

      var messages = <Message>[];
      // for (final messageMap in messageMapList) {
      //   messages.add(Message._fromMap(messageMap, this));
      // }
      return messages;
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Fetch at most count messages including and subsequent to the specified index.
  Future<List<Message>> getMessagesAfter(int index, int count) async {
    try {
      // final methodData = await TwilioConversationsClient._methodChannel
      //     .invokeMethod('Messages#getMessagesAfter', {
      //   'index': index,
      //   'count': count,
      //   'channelSid': _channel.sid,
      // });
      // final List<Map<String, dynamic>> messageMapList = methodData
      //     .map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r))
      //     .toList();

      var messages = <Message>[];
      // for (final messageMap in messageMapList) {
      //   messages.add(Message._fromMap(messageMap, this));
      // }
      return messages;
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Load last messages in chat.
  Future<List<Message>?> getLastMessages(int count) async {
    try {
      final methodData = await FlutterTwilioConversationsPlatform.instance
          .getLastMessages(count, _channel);
      print('methodData: $methodData');
      final List<Map<String, dynamic>> messageMapList = methodData
          .map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r))
          .toList();

      var messages = <Message>[];
      for (final messageMap in messageMapList) {
        print('messageMap: $messageMap');
        messages.add(Message._fromMap(messageMap, this));
      }
      return messages;
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Get message object by known index.
  Future<Message?> getMessageByIndex(int messageIndex) async {
    try {
      // final methodData = await TwilioConversationsClient._methodChannel
      //     .invokeMethod('Messages#getMessageByIndex',
      //         {'channelSid': _channel.sid, 'messageIndex': messageIndex});
      // final messageMap = Map<String, dynamic>.from(methodData);
      // return Message._fromMap(messageMap, this);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Set user last read message index for the channel.
  Future<int?> setLastReadMessageIndexWithResult(
      int lastReadMessageIndex) async {
    try {
      // return _lastReadMessageIndex = await TwilioConversationsClient
      //     ._methodChannel
      //     .invokeMethod('Messages#setLastReadMessageIndexWithResult', {
      //   'channelSid': _channel.sid,
      //   'lastReadMessageIndex': lastReadMessageIndex
      // });
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Increase user last read message index for the channel.
  ///
  /// Index is ignored if it is smaller than user current index.
  Future<int?> advanceLastReadMessageIndexWithResult(
      int lastReadMessageIndex) async {
    try {
      // return _lastReadMessageIndex = await TwilioConversationsClient
      //     ._methodChannel
      //     .invokeMethod('Messages#advanceLastReadMessageIndexWithResult', {
      //   'channelSid': _channel.sid,
      //   'lastReadMessageIndex': lastReadMessageIndex
      // });
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Set last read message index to last message index in channel.
  Future<int?> setAllMessagesReadWithResult() async {
    try {
      return _lastReadMessageIndex = await FlutterTwilioConversationsPlatform
          .instance
          .setAllMessagesReadWithResult(_channel);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Set last read message index before the first message index in channel.
  Future<int?> setNoMessagesReadWithResult() async {
    try {
      // return _lastReadMessageIndex =
      //     await TwilioConversationsClient._methodChannel.invokeMethod(
      //         'Messages#setNoMessagesReadWithResult',
      //         {'channelSid': _channel.sid});
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }
  //#endregion

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    _lastReadMessageIndex = map['lastReadMessageIndex'];
  }
}
