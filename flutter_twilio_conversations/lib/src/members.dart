part of flutter_twilio_conversations;

/// Provides access to channel members and allows to add/remove members.
class Members {
  //#region Private API properties
  final String _channelSid;
  //#endregion

  Members(this._channelSid);

  //#region Public API methods
  /// Return channel this member list belongs to.
  Future<Channel?> getChannel() async {
    var channel = await TwilioConversationsClient.chatClient?.channels
        ?.getChannel(_channelSid);
    return channel;
  }

  Future<List<Member>?> getMembersList() async {
    final membersListData = await FlutterTwilioConversationsPlatform.instance
        .getMembersList(_channelSid);
    if (membersListData?['membersList'] != null) {
      return membersListData['membersList']
          .map<Member>((m) => Member._fromMap(m.cast<String, dynamic>()))
          .toList();
    } else {
      return null;
    }
  }

  /// Get a channel member by identity.
  Future<Member> getMember(String identity) async {
    final memberData = await FlutterTwilioConversationsPlatform.instance
        .getMember(_channelSid, identity);
    return Member._fromMap(memberData?.cast<String, dynamic>());
  }

  /// Add member to the channel.
  ///
  /// The member object could refer to the member in some different channel, the add will be performed based on the member's identity.
  /// If the member is already present in the channel roster an error will be returned.
  Future<bool?> add(Member member) async {
    return addByIdentity(member.identity!);
  }

  /// Add specified username to this channel without inviting.
  ///
  /// If the member is already present in the channel roster an error will be returned.
  Future<bool?> addByIdentity(String identity) async {
    try {
      return FlutterTwilioConversationsPlatform.instance
          .addByIdentity(_channelSid, identity);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Invite specified member to this channel.
  Future<bool?> invite(Member member) async {
    return inviteByIdentity(member.identity!);
  }

  /// Invite specified username to this channel.
  Future<bool?> inviteByIdentity(String identity) async {
    try {
      return FlutterTwilioConversationsPlatform.instance
          .inviteByIdentity(_channelSid, identity);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }

  /// Remove specified member from this channel.
  Future<bool?> remove(Member member) async {
    return removeByIdentity(member.identity!);
  }

  /// Remove specified username from this channel.
  Future<bool?> removeByIdentity(String identity) async {
    try {
      return FlutterTwilioConversationsPlatform.instance
          .removeByIdentity(_channelSid, identity);
    } on PlatformException catch (err) {
      throw TwilioConversationsClient._convertException(err);
    }
  }
  //#endregion
}
