part of flutter_twilio_conversations;

/// Contains user information.
///
/// Unlike [User], this information won't be updated in realtime. To have refreshed data, user should query user descriptors again.
/// From the user descriptor you could obtain full [User] object by calling [UserDescriptor.subscribe].
class UserDescriptor {
  final String _friendlyName;

  final Attributes _attributes;

  final String _identity;

  final bool _isOnline;

  final bool _isNotifiable;

  /// Get user friendly name.
  String get friendlyName {
    return _friendlyName;
  }

  /// Get user attributes.
  Attributes get attributes {
    return _attributes;
  }

  /// Get user identity.
  String get identity {
    return _identity;
  }

  /// [User] online status.
  bool get isOnline {
    return _isOnline;
  }

  /// [User] notifiable status.
  bool get isNotifiable {
    return _isNotifiable;
  }

  UserDescriptor(
    this._friendlyName,
    this._attributes,
    this._identity,
    this._isOnline,
    this._isNotifiable,
  );

  /// Construct from a map.
  factory UserDescriptor._fromMap(Map<String, dynamic> map) {
    return UserDescriptor(
      map['friendlyName'],
      Attributes.fromMap(map['attributes'].cast<String, dynamic>()),
      map['identity'],
      map['isOnline'],
      map['isNotifiable'],
    );
  }

  /// Subscribe to the user object.
  Future<User> subscribe() async {
    final user = await TwilioConversationsClient.chatClient!.users
        ?.getAndSubscribeUser(_identity);
    return user!;
  }
}
