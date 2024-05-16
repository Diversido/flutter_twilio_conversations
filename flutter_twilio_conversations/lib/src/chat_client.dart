part of flutter_twilio_conversations;

//#region ChatClient events
class ChannelUpdatedEvent {
  final Channel channel;

  final ChannelUpdateReason reason;

  ChannelUpdatedEvent(this.channel, this.reason);
}

class UserUpdatedEvent {
  final User user;

  final UserUpdateReason? reason;

  UserUpdatedEvent(this.user, this.reason) : assert(reason != null);
}

class NewMessageNotificationEvent {
  final String channelSid;

  final String messageSid;

  final int messageIndex;

  NewMessageNotificationEvent(
      this.channelSid, this.messageSid, this.messageIndex);
}

class NotificationRegistrationEvent {
  final bool isSuccessful;
  final ErrorInfo error;

  NotificationRegistrationEvent(this.isSuccessful, this.error);
}
//#endregion

/// Chat client - main entry point for the Chat SDK.
class ChatClient {
  /// Stream for the native chat events.
  StreamSubscription<BaseChatClientEvent>? _chatStream;

  /// Stream for the notification events.
  StreamSubscription<dynamic>? _notificationStream;

  //#region Private API properties
  Channels? _channels;

  ConnectionState? _connectionState;

  final String? _myIdentity;

  Users? _users;

  bool? _isReachabilityEnabled;
  //#endregion

  //#region Public API properties
  /// [Channels] available to the current client.
  Channels? get channels {
    return _channels;
  }

  /// Current transport state
  ConnectionState? get connectionState {
    return _connectionState;
  }

  /// Get user identity for the current user.
  String? get myIdentity {
    return _myIdentity;
  }

  /// Get [Users] interface.
  Users? get users {
    return _users;
  }

  /// Get reachability service status.
  bool? get isReachabilityEnabled {
    return _isReachabilityEnabled;
  }
  //#endregion

  //#region Channel events
  final StreamController<Channel> _onChannelAddedCtrl =
      StreamController<Channel>.broadcast();

  /// Called when the current user has a channel added to their channel list, channel status is not specified.
  Stream<Channel>? onChannelAdded;

  final StreamController<Channel> _onChannelDeletedCtrl =
      StreamController<Channel>.broadcast();

  /// Called when one of the channel of the current user is deleted.
  Stream<Channel>? onChannelDeleted;

  final StreamController<Channel> _onChannelInvitedCtrl =
      StreamController<Channel>.broadcast();

  /// Called when the current user was invited to a channel, channel status is [ChannelStatus.INVITED].
  Stream<Channel>? onChannelInvited;

  final StreamController<Channel> _onChannelSynchronizationChangeCtrl =
      StreamController<Channel>.broadcast();

  /// Called when channel synchronization status changed.
  ///
  /// Use [Channel.synchronizationStatus] to obtain new channel status.
  Stream<Channel>? onChannelSynchronizationChange;

  final StreamController<ChannelUpdatedEvent> _onChannelUpdatedCtrl =
      StreamController<ChannelUpdatedEvent>.broadcast();

  /// Called when the channel is updated.
  ///
  /// [Channel] synchronization updates are delivered via different callback.
  Stream<ChannelUpdatedEvent>? onChannelUpdated;
  //#endregion

  //#region ChatClient events
  final StreamController<ChatClientSynchronizationStatus>
      _onClientSynchronizationCtrl =
      StreamController<ChatClientSynchronizationStatus>.broadcast();

  /// Called when client synchronization status changes.
  Stream<ChatClientSynchronizationStatus>? onClientSynchronization;

  final StreamController<ConnectionState> _onConnectionStateCtrl =
      StreamController<ConnectionState>.broadcast();

  /// Called when client connnection state has changed.
  Stream<ConnectionState>? onConnectionState;

  final StreamController<ErrorInfo> _onErrorCtrl =
      StreamController<ErrorInfo>.broadcast();

  /// Called when an error condition occurs.
  Stream<ErrorInfo>? onError;
  //#endregion

  //#region Notification events
  final StreamController<String> _onAddedToChannelNotificationCtrl =
      StreamController<String>.broadcast();

  /// Called when client receives a push notification for added to channel event.
  Stream<String>? onAddedToChannelNotification;

  final StreamController<String> _onInvitedToChannelNotificationCtrl =
      StreamController<String>.broadcast();

  /// Called when client receives a push notification for invited to channel event.
  Stream<String>? onInvitedToChannelNotification;

  final StreamController<NewMessageNotificationEvent>
      _onNewMessageNotificationCtrl =
      StreamController<NewMessageNotificationEvent>.broadcast();

  /// Called when client receives a push notification for new message.
  Stream<NewMessageNotificationEvent>? onNewMessageNotification;

  final StreamController<ErrorInfo> _onNotificationFailedCtrl =
      StreamController<ErrorInfo>.broadcast();

  /// Called when registering for push notifications fails.
  Stream<ErrorInfo>? onNotificationFailed;

  final StreamController<String> _onRemovedFromChannelNotificationCtrl =
      StreamController<String>.broadcast();

  /// Called when client receives a push notification for removed from channel event.
  Stream<String>? onRemovedFromChannelNotification;
  //#endregion

  //#region Token events
  final StreamController<void> _onTokenAboutToExpireCtrl =
      StreamController<void>.broadcast();

  /// Called when token is about to expire soon.
  ///
  /// In response, [ChatClient] should generate a new token and call [ChatClient.updateToken] as soon as possible.
  Stream<void>? onTokenAboutToExpire;

  final StreamController<void> _onTokenExpiredCtrl =
      StreamController<void>.broadcast();

  /// Called when token has expired.
  ///
  /// In response, [ChatClient] should generate a new token and call [ChatClient.updateToken] as soon as possible.
  Stream<void>? onTokenExpired;
  //#endregion

  //#region User events
  final StreamController<User> _onUserSubscribedCtrl =
      StreamController<User>.broadcast();

  /// Called when a user is subscribed to and will receive realtime state updates.
  Stream<User>? onUserSubscribed;

  final StreamController<User> _onUserUnsubscribedCtrl =
      StreamController<User>.broadcast();

  /// Called when a user is unsubscribed from and will not receive realtime state updates anymore.
  Stream<User>? onUserUnsubscribed;

  final StreamController<UserUpdatedEvent> _onUserUpdatedCtrl =
      StreamController<UserUpdatedEvent>.broadcast();

  /// Called when user info is updated for currently loaded users.
  Stream<UserUpdatedEvent>? onUserUpdated;

  final StreamController<NotificationRegistrationEvent>
      _onNotificationRegisteredCtrl =
      StreamController<NotificationRegistrationEvent>.broadcast();

  /// Called when attempt to register device for notifications has completed.
  Stream<NotificationRegistrationEvent>? onNotificationRegistered;

  final StreamController<NotificationRegistrationEvent>
      _onNotificationDeregisteredCtrl =
      StreamController<NotificationRegistrationEvent>.broadcast();

  /// Called when attempt to register device for notifications has completed.
  Stream<NotificationRegistrationEvent>? onNotificationDeregistered;
  //#endregion

  ChatClient(this._myIdentity) : assert(_myIdentity != null) {
    onChannelAdded = _onChannelAddedCtrl.stream;
    onChannelDeleted = _onChannelDeletedCtrl.stream;
    onChannelInvited = _onChannelInvitedCtrl.stream;
    onChannelSynchronizationChange = _onChannelSynchronizationChangeCtrl.stream;
    onChannelUpdated = _onChannelUpdatedCtrl.stream;
    onClientSynchronization = _onClientSynchronizationCtrl.stream;
    onConnectionState = _onConnectionStateCtrl.stream;
    onError = _onErrorCtrl.stream;
    onAddedToChannelNotification = _onAddedToChannelNotificationCtrl.stream;
    onInvitedToChannelNotification = _onInvitedToChannelNotificationCtrl.stream;
    onNewMessageNotification = _onNewMessageNotificationCtrl.stream;
    onNotificationFailed = _onNotificationFailedCtrl.stream;
    onRemovedFromChannelNotification =
        _onRemovedFromChannelNotificationCtrl.stream;
    onTokenAboutToExpire = _onTokenAboutToExpireCtrl.stream;
    onTokenExpired = _onTokenExpiredCtrl.stream;
    onUserSubscribed = _onUserSubscribedCtrl.stream;
    onUserUnsubscribed = _onUserUnsubscribedCtrl.stream;
    onUserUpdated = _onUserUpdatedCtrl.stream;
    // onNotificationRegistered = _onNotificationRegisteredCtrl.stream;
    // onNotificationDeregistered = _onNotificationDeregisteredCtrl.stream;
    // onNotificationFailed = _onNotificationFailedCtrl.stream;

    _chatStream = FlutterTwilioConversationsPlatform.instance
        .chatClientStream()!
        .listen((_parseEvents));
    // TwilioConversationsClient._chatChannel
    //     .receiveBroadcastStream(0)
    //     .listen(_parseEvents);
    // _notificationStream = TwilioConversationsClient._notificationChannel
    //     .receiveBroadcastStream(0)
    //     .listen(_parseNotificationEvents);
  }

  /// Construct from a map.
  factory ChatClient._fromMap(Map<String, dynamic> map) {
    var chatClient = ChatClient(map['myIdentity']);
    chatClient._updateFromMap(map);
    return chatClient;
  }

  //#region Public API methods
  /// Method to update the authentication token for this client.
  Future<void> updateToken(String token) async {
    try {
      return await TwilioConversationsClient._methodChannel.invokeMethod(
          'ChatClient#updateToken', <String, Object>{'token': token});
    } on PlatformException {
      return;
    }
  }

  /// Cleanly shuts down the messaging client when you are done with it.
  ///
  /// It will dispose() the client after shutdown, so it could not be reused.
  Future<void> shutdown() async {
    try {
      await Channels._shutdown();

      try {
        if (_chatStream != null) {
          print('ChatClient => TwilioLog shutdown chatStream');
          await _chatStream?.cancel();
        }
      } catch (e) {
        print('ChatClient => TwilioLog failed to cancel chat stream');
      }

      try {
        if (_notificationStream != null) {
          print('ChatClient => TwilioLog shutdown notificationStream');
          await _notificationStream?.cancel();
        }
      } catch (e) {
        print('ChatClient => TwilioLog failed to cancel notifications stream');
      }
      TwilioConversationsClient.chatClient = null;
      return await TwilioConversationsClient._methodChannel
          .invokeMethod('ChatClient#shutdown', null);
    } on PlatformException catch (err) {
      print('ChatClient => TwilioLog shutdown error: $err');
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Registers for push notifications. Uses APNs on iOS and FCM on Android.
  ///
  /// Token is only used on Android. iOS implementation retrieves APNs token itself.
  ///
  /// Twilio iOS SDK handles receiving messages when app is in the background and displaying
  /// notifications.
  Future<String> registerForNotification(String token) async {
    try {
      final isInit = await TwilioConversationsClient._methodChannel
          .invokeMethod(
              'registerForNotification', <String, Object>{'token': token});

      return isInit;
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Unregisters for push notifications.  Uses APNs on iOS and FCM on Android.
  ///
  /// Token is only used on Android. iOS implementation retrieves APNs token itself.
  Future<void> unregisterForNotification(String token) async {
    try {
      await TwilioConversationsClient._methodChannel.invokeMethod(
          'unregisterForNotification', <String, Object>{'token': token});
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Returns the notification used to launch the app (iOS Only)
  Future<void> handleReceivedNotification() async {
    try {
      return await TwilioConversationsClient._methodChannel
          .invokeMethod('handleReceivedNotification');
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }
  //#endregion

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    print('should update $map');
    _connectionState =
        EnumToString.fromString(ConnectionState.values, map['connectionState']);
    _isReachabilityEnabled = map['isReachabilityEnabled'];

    if (map['channels'] != null) {
      final channelsMap = Map<String, dynamic>.from(map['channels']);
      _channels ??= Channels._fromMap(channelsMap);
      _channels?._updateFromMap(channelsMap);
    }

    if (map['users'] != null) {
      final usersMap = Map<String, dynamic>.from(map['users']);
      _users ??= Users._fromMap(usersMap);
      _users?._updateFromMap(usersMap);
    }
  }

  /// Parse native chat client events to the right event streams.
  void _parseEvents(dynamic event) {
    print('ok here $event');

    final String eventName = event['name'];
    print(
        "ChatClient => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data'] ?? {});

    if (data['chatClient'] != null) {
      final chatClientMap = Map<String, dynamic>.from(data['chatClient']);
      _updateFromMap(chatClientMap);
    }

    ErrorInfo? exception;
    if (event['error'] != null) {
      final errorMap =
          Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'],
          errorMap['status'] as int);
    }

    Map<String, dynamic>? channelMap;
    if (data['channel'] != null) {
      channelMap =
          Map<String, dynamic>.from(data['channel'] as Map<dynamic, dynamic>);
    }

    Map<String, dynamic>? userMap;
    if (data['user'] != null) {
      userMap =
          Map<String, dynamic>.from(data['user'] as Map<dynamic, dynamic>);
    }

    var channelSid = data['channelSid'] as String?;

    dynamic reason;
    if (data['reason'] != null) {
      final reasonMap =
          Map<String, dynamic>.from(data['reason'] as Map<dynamic, dynamic>);
      if (reasonMap['type'] == 'channel') {
        reason = EnumToString.fromString(
            ChannelUpdateReason.values, reasonMap['value']);
      } else if (reasonMap['type'] == 'user') {
        reason = EnumToString.fromString(
            UserUpdateReason.values, reasonMap['value']);
      }
    }

    switch (eventName) {
      case 'addedToChannelNotification':
        _onAddedToChannelNotificationCtrl.add(channelSid!);
        break;
      case 'channelAdded':
        assert(channelMap != null);
        Channels._updateChannelFromMap(channelMap!);
        _onChannelAddedCtrl.add(Channels._channelsMap[channelMap['sid']]!);
        break;
      case 'channelDeleted':
        assert(channelMap != null);
        var channel = Channels._channelsMap[channelMap?['sid']];
        Channels._channelsMap[channelMap?['sid']] = null;
        channel?._updateFromMap(channelMap!);
        _onChannelDeletedCtrl.add(channel!);
        break;
      case 'channelInvited':
        assert(channelMap != null);
        Channels._updateChannelFromMap(channelMap!);
        _onChannelInvitedCtrl.add(Channels._channelsMap[channelMap['sid']]!);
        break;
      case 'channelSynchronizationChange':
        assert(channelMap != null);
        Channels._updateChannelFromMap(channelMap!);
        _onChannelSynchronizationChangeCtrl
            .add(Channels._channelsMap[channelMap['sid']]!);
        break;
      case 'channelUpdated':
        assert(channelMap != null);
        reason ??= ChannelUpdateReason.LAST_CONSUMED_MESSAGE_INDEX;
        Channels._updateChannelFromMap(channelMap!);
        _onChannelUpdatedCtrl.add(ChannelUpdatedEvent(
          Channels._channelsMap[channelMap['sid']]!,
          reason,
        ));
        break;
      case 'clientSynchronization':
        var synchronizationStatus = EnumToString.fromString(
            ChatClientSynchronizationStatus.values,
            data['synchronizationStatus']);
        print('TwilioConversationsPlugin.clientSynchronization => data: $data');
        if (synchronizationStatus != null) {
          _onClientSynchronizationCtrl.add(synchronizationStatus);
        } else {
          print(
              "ChatClient => TwilioLog got empty syncStatus: ${data['synchronizationStatus']}");
        }
        break;
      case 'connectionStateChange':
        var connectionState = EnumToString.fromString(
            ConnectionState.values, data['connectionState']);
        assert(connectionState != null);
        _connectionState = connectionState;
        _onConnectionStateCtrl.add(connectionState!);
        break;
      case 'error':
        assert(exception != null);
        _onErrorCtrl.add(exception!);
        break;
      case 'invitedToChannelNotification':
        _onInvitedToChannelNotificationCtrl.add(channelSid!);
        break;
      case 'newMessageNotification':
        var messageSid = data['messageSid'] as String;
        var messageIndex = data['messageIndex'] as int;
        _onNewMessageNotificationCtrl.add(
            NewMessageNotificationEvent(channelSid!, messageSid, messageIndex));
        break;
      case 'notificationFailed':
        assert(exception != null);
        _onNotificationFailedCtrl.add(exception!);
        break;
      case 'removedFromChannelNotification':
        assert(channelSid != null);
        _onRemovedFromChannelNotificationCtrl.add(channelSid!);
        break;
      case 'tokenAboutToExpire':
        _onTokenAboutToExpireCtrl.add(null);
        break;
      case 'tokenExpired':
        _onTokenExpiredCtrl.add(null);
        break;
      case 'userSubscribed':
        assert(userMap != null);
        users?._updateFromMap({
          'subscribedUsers': [userMap]
        });
        _onUserSubscribedCtrl.add(users!.getUserById(userMap?['identity'])!);
        break;
      case 'userUnsubscribed':
        assert(userMap != null);
        var user = users!.getUserById(userMap?['identity']);
        user?._updateFromMap(userMap!);
        users!.subscribedUsers
            .removeWhere((u) => u.identity == userMap?['identity']);
        _onUserUnsubscribedCtrl.add(user!);
        break;
      case 'userUpdated':
        assert(userMap != null);
        assert(reason != null);
        users?._updateFromMap({
          'subscribedUsers': [userMap]
        });
        _onUserUpdatedCtrl.add(UserUpdatedEvent(
            users!.getUserById(userMap?['identity'])!, reason));
        break;
      default:
        TwilioConversationsClient._log(
            "Event '$eventName' not yet implemented");
        break;
    }
  }

  /// Parse native chat client events to the right event streams.
  void _parseNotificationEvents(dynamic event) {
    final String eventName = event['name'];
    TwilioConversationsClient._log(
        "ChatClient => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    late ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap =
          Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int?, errorMap['message'],
          errorMap['status'] as int?);
    } else {
      exception = ErrorInfo(-1, 'Unknown error', 0);
    }

    switch (eventName) {
      case 'registered':
        _onNotificationRegisteredCtrl
            .add(NotificationRegistrationEvent(data['result'], exception));
        break;
      case 'deregistered':
        _onNotificationDeregisteredCtrl
            .add(NotificationRegistrationEvent(data['result'], exception));
        break;
      default:
        TwilioConversationsClient._log(
            "Notification event '$eventName' not yet implemented");
        break;
    }
  }
}
