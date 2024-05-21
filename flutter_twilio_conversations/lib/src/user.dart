part of flutter_twilio_conversations;

class User {
  //#region Private API properties
  String? _friendlyName;

  final Attributes? _attributes;

  final String? _identity;

  bool? _isOnline;

  bool? _isNotifiable;

  bool? _isSubscribed;
  //#endregion

  //#region Public API properties
  /// Method that returns the friendlyName from the user info.
  String? get friendlyName {
    return _friendlyName;
  }

  /// Returns the identity of the user.
  String? get identity {
    return _identity;
  }

  /// Return user's online status, if available,
  bool? get isOnline {
    return _isOnline;
  }

  /// Return user's push reachability.
  bool? get isNotifiable {
    return _isNotifiable;
  }

  /// Check if this user receives real-time status updates.
  bool? get isSubscribed {
    return _isSubscribed;
  }

  /// Get attributes map
  Attributes? get attributes {
    return _attributes;
  }
  //#endregion

  User(this._identity, this._attributes)
      : assert(_identity != null),
        assert(_attributes != null);

  /// Construct from a map.
  factory User._fromMap(Map<String, dynamic> map) {
    Attributes attributes;

    try {
      attributes =
          Attributes.fromMap(map['attributes'].cast<String, dynamic>());
      print('Map for Twilio user is: $map');
    } catch (e) {
      print('Failed to map Twilio user from map $map: $e');
      attributes = Attributes(AttributesType.STRING, '{}');
    }

    var user = User(
      map['identity'],
      attributes,
    );
    user._updateFromMap(map);
    return user;
  }

  //#region Public API methods
  Future<void> unsubscribe() async {
    try {
      // await TwilioConversationsClient._methodChannel
      //     .invokeMethod('User#unsubscribe', {'identity': _identity});
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }
  //#endregion

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    _friendlyName =
        (map['friendlyName'] is String ? map['friendlyName'] : null) ??
            'friendlyName';
    _isOnline = (map['isOnline'] is bool ? map['isOnline'] : null) ?? true;
    _isNotifiable =
        (map['isNotifiable'] is bool ? map['isNotifiable'] : null) ?? true;
    _isSubscribed =
        (map['isSubscribed'] is bool ? map['isSubscribed'] : null) ?? true;
  }
}
