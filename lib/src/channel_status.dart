part of flutter_twilio_conversations;

/// Represents the various states of the user with respect to the channel.
enum ChannelStatus {
  /// [User] has been invited to this channel.
  INVITED,

  /// [User] has joined this channel.
  JOINED,

  /// [User] has NOT been invited to nor joined this channel.
  NOT_PARTICIPATING,

  /// [Channel] has not been synched and it's actual status is unknown.
  ///
  /// ChannelDescriptors will have this value set for status.
  UNKNOWN,
}
