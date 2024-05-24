part of flutter_twilio_conversations;

/// Provides access to channels collection, allows to create new channels.
class Channels {
  //#region Private API properties
  static final Map<String, Channel?> _channelsMap = {};
  //#endregion

  //#region Public API properties
  /// Request list of user's joined channels.
  List<Channel> get subscribedChannels {
    return _channelsMap.values
        .where((channel) => channel != null && channel._isSubscribed!)
        .toList()
        .map((e) => e!)
        .toList();
  }
  //#endregion

  Channels();

  /// Construct from a map.
  factory Channels._fromMap(Map<String, dynamic> map) {
    var channels = Channels();
    print('p: channels from map $map');
    channels._updateFromMap(map); //TODO martin when?
    return channels;
  }

  //#region Public API methods
  /// Create a [Channel] with friendly name and type.
  ///
  /// This operation creates a new channel entity on the backend.
  Future<Channel> createChannel(
      String friendlyName, ChannelType channelType) async {
    print("p: create channel called");
    try {
      final methodData = await FlutterTwilioConversationsPlatform.instance
          .createChannel(
              friendlyName, EnumToString.convertToString(channelType));

      final channelMap = Map<String, dynamic>.from(methodData);
      _updateChannelFromMap(channelMap);
      return _channelsMap[channelMap['sid']]!;
    } on PlatformException catch (err) {
      if (err.code == 'ERROR' || err.code == 'IllegalArgumentException') {
        rethrow;
      }
      throw ErrorInfo(int.parse(err.code), err.message, err.details as int);
    }
  }

  /// Retrieves a [Channel] with the specified SID or unique name.
  Future<Channel> getChannel(String channelSidOrUniqueName) async {
    print("p: get channel called");
    try {
      final methodData = FlutterTwilioConversationsPlatform.instance
          .getChannel(channelSidOrUniqueName);

      final channelMap = Map<String, dynamic>.from(methodData as Map);
      _updateChannelFromMap(channelMap);
      return _channelsMap[channelMap['sid']]!;
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Request list of public channels that the current user has not joined.
  ///
  /// This command will return a list of [ChannelDescriptor]s. These are the channels that are public and are not joined by current user.
  /// To get channels already joined by current user see [Channels.getUserChannelsList].
  ///
  /// Returned list is wrapped in a [Paginator].
  Future<Paginator<ChannelDescriptor>?> getPublicChannelsList() async {
    try {
      // final methodData = await TwilioConversationsClient._methodChannel
      //     .invokeMethod('Channels#getPublicChannelsList');
      // final paginatorMap = Map<String, dynamic>.from(methodData);
      // return Paginator<ChannelDescriptor>._fromMap(paginatorMap);
      return null;
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Request list of channels user have joined.
  ///
  /// Per Android docs: This command will return a list of [ChannelDescriptor]s. These are the channels that are joined by current user, regardless of if they are public or private.
  /// To get public channels not yet joined by current user see [Channels.getPublicChannelsList].
  ///
  /// Per iOS docs: Retrieve a list of channel descriptors the user has a participation state on, for example invited, joined, creator.
  ///
  /// Returned list is wrapped in a [Paginator].
  Future<Paginator<ChannelDescriptor>?> getUserChannelsList() async {
    try {
      return null;
      // final methodData = await TwilioConversationsClient._methodChannel
      //     .invokeMethod('Channels#getUserChannelsList');
      // final paginatorMap = Map<String, dynamic>.from(methodData);
      // return Paginator<ChannelDescriptor>._fromMap(paginatorMap);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Get list of all [Channel] members with a given identity.
  ///
  /// The effect of this function is to find and return all Member instances across multiple channels with the given identity.
  Future<List<Member>?> getMembersByIdentity(String identity) async {
    try {
      return null;
      //   final methodData = await TwilioConversationsClient._methodChannel
      //       .invokeMethod(
      //           'Channels#getMembersByIdentity', {'identity': identity});
      //   final List<Map<String, dynamic>> memberMapList = methodData
      //       .map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r))
      //       .toList();

      //   var memberList = <Member>[];
      //   for (final memberMap in memberMapList) {
      //     memberList.add(Member._fromMap(memberMap));
      //   }
      //   return memberList;
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }
  //#endregion

  /// Cleanly shuts down all the active channels.
  ///
  /// Each cached channel reference will be disposed and removed from the cache.
  static Future<void> _shutdown() async {
    _channelsMap.forEach((key, channel) async {
      try {
        await channel?._dispose();
        _channelsMap.remove(key);
      } catch (e) {
        print('ChatClient => TwilioLog failed to shutdown channels');
      }
    });
  }

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    if (map['subscribedChannels'] != null) {
      final List<Map<String, dynamic>> subscribedChannelsList =
          map['subscribedChannels']
              .map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r))
              .toList();
      _channelsMap.values.forEach((channel) => channel!._isSubscribed = false);
      for (final subscribedChannelMap in subscribedChannelsList) {
        var sid = subscribedChannelMap['sid'];
        _updateChannelFromMap(subscribedChannelMap);
        _channelsMap[sid]!._isSubscribed = true;
        print(
            'pc: updated subscribed $sid = ${_channelsMap[sid]!._isSubscribed}');
      }
    }
  }

  /// Update individual channel from a map.
  static void _updateChannelFromMap(Map<String, dynamic> channelMap) {
    // print('p: updating channel from map');
    var sid = channelMap['sid'];
    if (_channelsMap[sid] == null) {
      _channelsMap[sid] = Channel._fromMap(channelMap);
      _channelsMap[sid]!._isSubscribed = false;
    } else {
      _channelsMap[sid]!._updateFromMap(channelMap);
    }
  }
}
