part of flutter_twilio_conversations;

/// Representation of a [Channel] member object.
class Member {
  //#region Private API properties
  final String _sid;

  final Attributes? _attributes;

  int? _lastReadMessageIndex;

  String? _lastConsumptionTimestamp;

  String? _channelSid;

  String? _identity;

  /// Also known as channelType
  final MemberType _type;
  //#endregion

  //#region Public API properties
  /// Returns unique identifier of a member on a [Channel].
  String get sid {
    return _sid;
  }

  /// Returns members last read message index for this channel.
  int? get lastReadMessageIndex {
    return _lastReadMessageIndex;
  }

  /// Return members last read message timestamp for this channel.
  String? get lastConsumptionTimestamp {
    return _lastConsumptionTimestamp;
  }

  /// Returns user identity for the current member.
  String? get identity {
    return _identity;
  }

  /// Returns [MemberType] of current member. Also known as channelType.
  MemberType get type {
    return _type;
  }

  /// Get attributes map
  Attributes? get attributes {
    return _attributes;
  }
  //#endregion

  Member(this._sid, this._type, this._channelSid, this._attributes)
      : assert(_channelSid != null),
        assert(_attributes != null);

  static Member? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return Member._fromMap(map);
  }

  /// Construct from a map.
  factory Member._fromMap(Map<String, dynamic> map) {
    var member = Member(
      map['sid'],
      EnumToString.fromString(MemberType.values, map['type'])!,
      map['channelSid'],
      Attributes.fromMap(map['attributes'].cast<String, dynamic>()),
    );
    member._updateFromMap(map);
    return member;
  }

  //#region Public API methods
  /// Returns the channel this member belong<s to.
  Future<Channel?> getChannel() async {
    var channel = await TwilioConversationsClient.chatClient?.channels!
        .getChannel(_channelSid!);
    return channel;
  }

  /// Return user descriptor for current member.
  Future<UserDescriptor> getUserDescriptor() async {
    final userDescriptorData = await TwilioConversationsClient._methodChannel
        .invokeMethod('Member#getUserDescriptor', {
      'identity': _identity,
      'channelSid': _channelSid,
    });
    final userDescriptor =
        UserDescriptor._fromMap(userDescriptorData.cast<String, dynamic>());
    return userDescriptor;
  }

  /// Return subscribed user object for current member.
  Future<User> getAndSubscribeUser() async {
    try {
      final methodData = await TwilioConversationsClient._methodChannel
          .invokeMethod('Member#getAndSubscribeUser', {
        'memberSid': _sid,
        'channelSid': _channelSid,
      });
      final userMap = Map<String, dynamic>.from(methodData);
      return User._fromMap(userMap);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Set attributes associated with this member.
  Future<Map<String, dynamic>> setAttributes(
      Map<String, dynamic> attributes) async {
    try {
      return Map<String, dynamic>.from(await TwilioConversationsClient
          ._methodChannel
          .invokeMethod('Member#setAttributes', {
        'memberSid': _sid,
        'channelSid': _channelSid,
        'attributes': attributes
      }));
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }
  //#endregion

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    _lastReadMessageIndex = map['lastReadMessageIndex'];
    _lastConsumptionTimestamp = map['lastConsumptionTimestamp'];
    _identity = map['identity'];
  }
}
