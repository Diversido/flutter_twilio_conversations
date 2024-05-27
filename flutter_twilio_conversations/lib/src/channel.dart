part of flutter_twilio_conversations;

//#region Channel events
class MessageUpdatedEvent {
  final Message message;

  final MessageUpdateReason? reason;

  MessageUpdatedEvent(this.message, this.reason) : assert(reason != null);
}

class MemberUpdatedEvent {
  final Member member;

  final MemberUpdateReason? reason;

  MemberUpdatedEvent(this.member, this.reason) : assert(reason != null);
}

class TypingEvent {
  final Channel channel;

  final Member member;

  TypingEvent(this.channel, this.member);
}
//#endregion

/// Container for channel object.
class Channel {
  /// Local caching event stream so each instance will use the same stream.
  static final Map<String, Stream> _channelStreams = {};
  static final Map<String, StreamSubscription> _channelStreamSubscriptions = {};

  //#region Private API properties
  final String _sid;

  final ChannelType? _type;

  Attributes? _attributes;

  Messages? _messages;

  ChannelStatus? _status;

  Members? _members;

  ChannelSynchronizationStatus? _synchronizationStatus;

  DateTime? _dateCreated;

  String? _createdBy;

  DateTime? _dateUpdated;

  DateTime? _lastMessageDate;

  int? _lastMessageIndex;

  bool? _isSubscribed;

  bool _hasSynchronized = false;
  //#endregion

  //#region Public API properties
  /// Get unique identifier for this channel.
  ///
  /// This identifier can be used to get this [Channel] again using [Channels.getChannel].
  /// The channel SID is persistent and globally unique.
  String get sid {
    return _sid;
  }

  /// The channel type.
  ChannelType? get type {
    return _type;
  }

  /// Get messages object that allows access to messages in the channel.
  Messages? get messages {
    return _messages;
  }

  /// Get the current user's participation status on this channel.
  ChannelStatus? get status {
    return _status;
  }

  /// Get members object that allows access to member roster in the channel.
  ///
  /// You need to synchronize the channel before you can call this method unless you just joined the channel, in which case it synchronizes automatically.
  Members? get members {
    return _members;
  }

  /// Get the current synchronization status for channel.
  ChannelSynchronizationStatus? get synchronizationStatus {
    return _synchronizationStatus;
  }

  /// Get creation date of the channel.
  DateTime? get dateCreated {
    return _dateCreated;
  }

  /// Get creator of the channel.
  String? get createdBy {
    return _createdBy;
  }

  /// Get update date of the channel.
  ///
  /// Update date changes when channel attributes, friendly name or unique name are modified. It will not change in response to messages posted or members added or removed.
  DateTime? get dateUpdated {
    return _dateUpdated;
  }

  /// Get last message date in the channel.
  DateTime? get lastMessageDate {
    return _lastMessageDate;
  }

  /// Get last message's index in the channel.
  int? get lastMessageIndex {
    return _lastMessageIndex;
  }

  /// Get attributes map
  Attributes? get attributes {
    return _attributes;
  }

  /// True if the channel has, in the lifetime of the ChatClient reached
  /// ChannelSynchronizationStatus.ALL
  ///
  /// This has been added to address the fact that when a user Joins a channel
  /// That channels synchronization status reverts to IDENTIFIER, and never
  /// returns to ALL
  bool get hasSynchronized {
    return _hasSynchronized;
  }
  //#endregion

  //#region Message events
  final StreamController<Message> _onMessageAddedCtrl =
      StreamController<Message>.broadcast();

  /// Called when a [Message] is added to the channel the current user is subscribed to.
  ///
  /// You could obtain the [Channel] where it was added by using [Message.getChannel] or [Message.channelSid].
  Stream<Message>? onMessageAdded;

  final StreamController<MessageUpdatedEvent> _onMessageUpdatedCtrl =
      StreamController<MessageUpdatedEvent>.broadcast();

  /// Called when a [Message] is changed in the channel the current user is subscribed to.
  ///
  /// You could obtain the [Channel] where it was updated by using [Message.getChannel] or [Message.channelSid].
  /// [Message] change events include body updates and attribute updates.
  Stream<MessageUpdatedEvent>? onMessageUpdated;

  final StreamController<Message> _onMessageDeletedCtrl =
      StreamController<Message>.broadcast();

  /// Called when a [Message] is deleted from the channel the current user is subscribed to.
  ///
  /// You could obtain the [Channel] where it was deleted by using [Message.getChannel] or [Message.channelSid].
  Stream<Message>? onMessageDeleted;
  //#endregion

  //#region Member events
  final StreamController<Member> _onMemberAddedCtrl =
      StreamController<Member>.broadcast();

  /// Called when a [Member] is added to the channel the current user is subscribed to.
  ///
  /// You could obtain the [Channel] where it was added by using [Member.getChannel].
  Stream<Member>? onMemberAdded;

  final StreamController<MemberUpdatedEvent> _onMemberUpdatedCtrl =
      StreamController<MemberUpdatedEvent>.broadcast();

  /// Called when a [Member] is changed in the channel the current user is subscribed to.
  ///
  /// You could obtain the [Channel] where it was updated by using [Member.getChannel].
  /// [Member] change events include body updates and attribute updates.
  Stream<MemberUpdatedEvent>? onMemberUpdated;

  final StreamController<Member> _onMemberDeletedCtrl =
      StreamController<Member>.broadcast();

  /// Called when a [Member] is deleted from the channel the current user is subscribed to.
  ///
  /// You could obtain the [Channel] where it was deleted by using [Member.getChannel].
  Stream<Member>? onMemberDeleted;
  //#endregion

  //#region Typing events
  final StreamController<TypingEvent> _onTypingStartedCtrl =
      StreamController<TypingEvent>.broadcast();

  /// Called when an [Member] starts typing in a [Channel].
  Stream<TypingEvent>? onTypingStarted;

  final StreamController<TypingEvent> _onTypingEndedCtrl =
      StreamController<TypingEvent>.broadcast();

  /// Called when an [Member] stops typing in a [Channel\.
  ///
  /// Typing indicator has a timeout after user stops typing to avoid triggering it too often. Expect about 5 seconds delay between stopping typing and receiving typing ended event.
  Stream<TypingEvent>? onTypingEnded;
  //#endregion

  //#region Synchronization event
  final StreamController<Channel> _onSynchronizationChangedCtrl =
      StreamController<Channel>.broadcast();

  /// Called when channel synchronization status changed.
  Stream<Channel>? onSynchronizationChanged;
  //#endregion

  Channel(
    this._sid,
    this._createdBy,
    this._dateCreated,
    this._type,
    this._attributes,
  )   : assert(_type != null),
        assert(_attributes != null) {
    onMessageAdded = _onMessageAddedCtrl.stream;
    onMessageUpdated = _onMessageUpdatedCtrl.stream;
    onMessageDeleted = _onMessageDeletedCtrl.stream;
    onMemberAdded = _onMemberAddedCtrl.stream;
    onMemberUpdated = _onMemberUpdatedCtrl.stream;
    onMemberDeleted = _onMemberDeletedCtrl.stream;
    onTypingStarted = _onTypingStartedCtrl.stream;
    onTypingEnded = _onTypingEndedCtrl.stream;
    onSynchronizationChanged = _onSynchronizationChangedCtrl.stream;

    _messages = Messages(this);
    _members = Members(_sid);
    print('p: channel constructor called $_sid');

    // _channelStreams[_sid] ??= EventChannel('flutter_twilio_conversations/$_sid')
    //     .receiveBroadcastStream(0);

    // _channelStreamSubscriptions[_sid] ??= FlutterTwilioConversationsPlatform
    //     .instance
    //     .channelStream(_sid)!
    //     .listen((_parseEvents));
    //  _channelStreams[_sid]!.listen(_parseEvents);
  }

  /// Construct from a map.
  factory Channel._fromMap(Map<String, dynamic> map) {
    var channel = Channel(
      map['sid'],
      map['createdBy'],
      map['dateCreated'] != null ? DateTime.parse(map['dateCreated']) : null,
      ChannelType.PUBLIC,
      Attributes.fromMap(map['attributes'].cast<String, dynamic>()),
    );
    channel._updateFromMap(map);
    return channel;
  }

  //#region Public API methods
  /// Join the current user to this channel.
  ///
  /// Joining the channel is a prerequisite for sending and receiving messages in the channel. You can join the channel or you could be added to it by another channel member.
  ///
  /// You could also be invited to the channel by another member. In this case you will not be added to the channel right away but instead receive a [ChatClient.onChannelInvited] callback.
  /// You accept the invitation by calling [Channel.join] or decline it by calling [Channel.declineInvitation].
  Future<void> join() async {
    try {
      await FlutterTwilioConversationsPlatform.instance.joinChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Leave this channel.
  Future<void> leave() async {
    try {
      await FlutterTwilioConversationsPlatform.instance.leaveChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Indicate that Member is typing in this channel.
  ///
  /// You should call this method to indicate that a local user is entering a message into current channel. The typing state is forwarded to users subscribed to this channel through [Channel.onTypingStarted] and [Channel.onTypingEnded] callbacks.
  /// After approximately 5 seconds after the last [Channel.typing] call the SDK will emit [Channel.onTypingEnded] signal.
  /// One common way to implement this indicator is to call [Channel.typing] repeatedly in response to key input events.
  Future<void> typing() async {
    try {
      await FlutterTwilioConversationsPlatform.instance.typingChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Decline an invite to this channel.
  ///
  /// If a user is invited to the channel, they can choose to either [Channel.join] the channel to accept the invitation or [Channel.declineInvitation] to decline.
  Future<void> declineInvitation() async {
    try {
      await FlutterTwilioConversationsPlatform.instance
          .declineInvitationChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Destroy this channel.
  ///
  /// Note: this will delete the [Channel] and all associated metadata from the service instance. [Members] in the channel and all channel messages, including posted media will be lost.
  /// There is no undo for this operation!
  Future<void> destroy() async {
    try {
      await FlutterTwilioConversationsPlatform.instance
          .declineInvitationChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Get total number of messages in the channel.
  //
  /// This method is semi-realtime. This means that this data will be eventually correct, but will also possibly be incorrect for a few seconds.
  /// The Chat system does not provide real time events for counter values changes.
  ///
  /// So this is quite useful for any UI badges, but is not recommended to build any core application logic based on these counters being accurate in real time.
  ///
  /// This function performs an async call to service to obtain up-to-date message count.
  /// The retrieved value is then cached for 5 seconds so there is no reason to call this function more often than once in 5 seconds.
  Future<int> getMessagesCount() async {
    try {
      return await FlutterTwilioConversationsPlatform.instance
          .getMessagesCountChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Get number of unread messages in the channel.
  ///
  /// This method is semi-realtime. This means that this data will be eventually correct, but will also possibly be incorrect for a few seconds.
  /// The Chat system does not provide real time events for counter values changes.
  ///
  /// So this is quite useful for any “unread messages count” badges, but is not recommended to build any core application logic based on these counters being accurate in real time.
  ///
  /// This function performs an async call to service to obtain up-to-date message count.
  /// The retrieved value is then cached for 5 seconds so there is no reason to call this function more often than once in 5 seconds.
  Future<int?> getUnreadMessagesCount() async {
    try {
      return await FlutterTwilioConversationsPlatform.instance
          .getUnreadMessagesCountChannel(_sid);
    } on PlatformException {
      return 0;
    }
  }

  /// Get total number of members in the channel roster.
  ///
  /// This method is semi-realtime. This means that this data will be eventually correct, but will also possibly be incorrect for a few seconds.
  /// The Chat system does not provide real time events for counter values changes.
  ///
  /// So this is quite useful for any UI badges, but is not recommended to build any core application logic based on these counters being accurate in real time.
  ///
  /// This function performs an async call to service to obtain up-to-date member count.
  /// The retrieved value is then cached for 5 seconds so there is no reason to call this function more often than once in 5 seconds.
  Future<int> getMembersCount() async {
    try {
      return await FlutterTwilioConversationsPlatform.instance
          .getMembersCountChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Set attributes associated with this channel.
  ///
  /// Attributes are stored as a JSON format object, of arbitrary internal structure. Channel attributes are limited in size to 32Kb.
  /// Passing null attributes will reset channel attributes string to empty.
  Future<Map<String, dynamic>> setAttributes(
      Map<String, dynamic> attributes) async {
    try {
      return Map<String, dynamic>.from(await FlutterTwilioConversationsPlatform
          .instance
          .setAttributesChannel(_sid, attributes));
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Get friendly name of the channel.
  ///
  /// Friendly name is a free-form text string, it is not unique and could be used for user-friendly channel name display in the UI.
  Future<String> getFriendlyName() async {
    try {
      return await FlutterTwilioConversationsPlatform.instance
          .getFriendlyNameChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Update the friendly name for this channel.
  Future<String> setFriendlyName(String friendlyName) async {
    try {
      return await FlutterTwilioConversationsPlatform.instance
          .setFriendlyNameChannel(_sid, friendlyName);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// The current user's notification level on this channel.
  ///
  /// This property reflects whether the user will receive push notifications for activity on this channel.
  Future<NotificationLevel?> getNotificationLevel() async {
    try {
      return EnumToString.fromString(
          NotificationLevel.values,
          await FlutterTwilioConversationsPlatform.instance
              .getNotificationLevelChannel(_sid));
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Set the user's notification level for the channel.
  ///
  /// This property determines whether the user will receive push notifications for activity on this channel.
  Future<NotificationLevel?> setNotificationLevel(
      NotificationLevel notificationLevel) async {
    try {
      return EnumToString.fromString(
        NotificationLevel.values,
        await FlutterTwilioConversationsPlatform.instance
            .setNotificationLevelChannel(
          _sid,
          EnumToString.convertToString(notificationLevel),
        ),
      );
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Get unique name of the channel.
  ///
  /// Unique name is similar to SID but can be specified by the user.
  Future<String> getUniqueName() async {
    try {
      return await FlutterTwilioConversationsPlatform.instance
          .getUniqueNameChannel(_sid);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Update the unique name for this channel.
  ///
  /// Unique name is unique within Service Instance. You will receive an error if you try to set a name that is not unique.
  Future<String> setUniqueName(String uniqueName) async {
    try {
      return await FlutterTwilioConversationsPlatform.instance
          .setUniqueNameChannel(_sid, uniqueName);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }
  //#endregion

  /// Safely dispose of this channel.
  ///
  /// Cancels the [StreamSubscription] and removes the cached reference of this channel.
  Future<void> _dispose() async {
    await _channelStreamSubscriptions[_sid]?.cancel();
    _channelStreamSubscriptions.remove(_sid);
    _channelStreams.remove(_sid);
  }

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    // print("p: updateFromMap in channel $map");
    _synchronizationStatus = EnumToString.fromString(
        ChannelSynchronizationStatus.values, map['synchronizationStatus']);
    if (_synchronizationStatus == ChannelSynchronizationStatus.ALL) {
      _hasSynchronized = true;
    }

    if (map['messages'] != null) {
      //  print("p: in channel updating messages");
      final messagesMap = Map<String, dynamic>.from(map['messages']);
      _messages?._updateFromMap(messagesMap);
    }

    if (map['attributes'] != null) {
      // print("p: in channel updating attributes");
      _attributes =
          Attributes.fromMap(map['attributes'].cast<String, dynamic>());
    }

    _status = EnumToString.fromString(ChannelStatus.values, map['status']);
    // print("p: status: $_status");
    _createdBy ??= map['createdBy'];

    _dateCreated ??=
        map['dateCreated'] != null ? DateTime.parse(map['dateCreated']) : null;
    _dateUpdated =
        map['dateUpdated'] != null ? DateTime.parse(map['dateUpdated']) : null;

    _lastMessageDate = map['lastMessageDate'] != null
        ? DateTime.parse(map['lastMessageDate'])
        : null;
   // print("p: _lastMessageDate passed");
    _lastMessageIndex = map['lastMessageIndex'];
  }

  /// Parse native channel events to the right event streams.
  void _parseEvents(dynamic event) {
   // print('p: parse Event Channel');
    final String eventName = event['name'];
    TwilioConversationsClient._log(
        "Channel => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    if (data['channel'] != null) {
      final channelMap = Map<String, dynamic>.from(data['channel']);
      _updateFromMap(channelMap);
    }

    Message? message;
    if (data['message'] != null) {
      final messageMap =
          Map<String, dynamic>.from(data['message'] as Map<dynamic, dynamic>);
      message = Message._fromMap(messageMap, messages!);
    }

    Member? member;
    if (data['member'] != null) {
      final memberMap =
          Map<String, dynamic>.from(data['member'] as Map<dynamic, dynamic>);
      member = Member._fromMap(memberMap);
    }

    dynamic reason;
    if (data['reason'] != null) {
      final reasonMap =
          Map<String, dynamic>.from(data['reason'] as Map<dynamic, dynamic>);
      switch (reasonMap['type']) {
        case 'message':
          reason = EnumToString.fromString(
              MessageUpdateReason.values, reasonMap['value']);
          break;
        case 'member':
          reason = EnumToString.fromString(
              MemberUpdateReason.values, reasonMap['value']);
          break;
      }
    }

    switch (eventName) {
      case 'messageAdded':
        if (message != null) {
          _onMessageAddedCtrl.add(message);
        }
        break;
      case 'messageUpdated':
        assert(reason != null);
        _onMessageUpdatedCtrl.add(MessageUpdatedEvent(message!, reason));
        break;
      case 'messageDeleted':
        _onMessageDeletedCtrl.add(message!);
        break;
      case 'memberAdded':
        _onMemberAddedCtrl.add(member!);
        break;
      case 'memberUpdated':
        if (reason != null) {
          _onMemberUpdatedCtrl.add(MemberUpdatedEvent(member!, reason));
        }
        break;
      case 'memberDeleted':
        _onMemberDeletedCtrl.add(member!);
        break;
      case 'typingStarted':
        _onTypingStartedCtrl.add(TypingEvent(this, member!));
        break;
      case 'typingEnded':
        _onTypingEndedCtrl.add(TypingEvent(this, member!));
        break;
      case 'synchronizationChanged':
        _onSynchronizationChangedCtrl.add(this);
        break;
      default:
        TwilioConversationsClient._log(
            "Event '$eventName' not yet implemented");
        break;
    }
  }

  @override
  String toString() => 'Channel{$sid}';
}
