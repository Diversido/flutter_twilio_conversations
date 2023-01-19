part of flutter_twilio_conversations;

/// Contains channel information.
///
/// Unlike [Channel], this information won't be updated in realtime.
/// To have refreshed data, user should query channel descriptors again.
///
/// From the channel descriptor you could obtain full [Channel] object by calling [ChannelDescriptor.getChannel].
class ChannelDescriptor {
  //#region Private API properties
  final String _sid;

  String? _friendlyName;

  String? _uniqueName;

  Attributes? _attributes;

  final DateTime _dateCreated;

  DateTime? _dateUpdated;

  final String _createdBy;

  int? _membersCount;

  int? _messagesCount;
  //#endregion

  //#region Public API properties
  /// Get channel SID.
  String get sid {
    return _sid;
  }

  /// Get channel friendly name.
  String? get friendlyName {
    return _friendlyName;
  }

  /// Get channel unique name.
  String? get uniqueName {
    return _uniqueName;
  }

  /// Get channel attributes.
  Attributes? get attributes {
    return _attributes;
  }

  /// Get the current user's participation status on this channel.
  ///
  /// Since for [ChannelDescriptor]s the status is unknown this function will always return [ChannelStatus.UNKNOWN].
  Future<ChannelStatus> get status async {
    var channel = await getChannel();
    return channel!.status!;
  }

  /// Get channel create date.
  DateTime get dateCreated {
    return _dateCreated;
  }

  /// Get channel update date.
  DateTime? get dateUpdated {
    return _dateUpdated;
  }

  /// Get creator of the channel.
  String get createdBy {
    return _createdBy;
  }

  /// Get number of members.
  int? get membersCount {
    return _membersCount;
  }

  /// Get number of messages.
  int? get messagesCount {
    return _messagesCount;
  }

  /// Get number of unread messages.
  Future<int?> get unreadMessagesCount async {
    var channel = await getChannel();
    return channel!.getUnreadMessagesCount();
  }
  //#endregion

  ChannelDescriptor(
    this._sid,
    this._dateCreated,
    this._createdBy,
  );

  /// Construct from a map.
  factory ChannelDescriptor._fromMap(Map<String, dynamic> map) {
    var channelDescriptor = ChannelDescriptor(
      map['sid'],
      DateTime.parse(map['dateCreated']),
      map['createdBy'],
    );
    channelDescriptor._updateFromMap(map);
    return channelDescriptor;
  }

  //#region Public API methods
  /// Retrieve a full [Channel] object.
  Future<Channel?> getChannel() async {
    var channel =
        await TwilioConversationsClient.chatClient?.channels?.getChannel(_sid);
    return channel;
  }
  //#endregion

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    _uniqueName = map['uniqueName'];
    _friendlyName = map['friendlyName'];
    assert(_friendlyName != null);
    _attributes = Attributes.fromMap(map['attributes'].cast<String, dynamic>());
    _dateUpdated = DateTime.parse(map['dateUpdated']);
    assert(_dateUpdated != null);
    _membersCount = map['membersCount'];
    assert(_membersCount != null);
    _messagesCount = map['messagesCount'];
    assert(_messagesCount != null);
  }
}
