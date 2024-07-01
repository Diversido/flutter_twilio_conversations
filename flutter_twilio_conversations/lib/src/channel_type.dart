part of flutter_twilio_conversations;

/// Represents the channel's visibility.
///
/// Public channels are visible to all users on the service instance and can be obtained in a list via call to [Channels.getPublicChannelsList].
///
/// Private channels are only visible to participating users. Their list can be obtained via call to [Channels.getUserChannelsList].
enum ChannelType {
  /// [Channel] is publicly visible.
  PUBLIC,

  /// [Channel] is private and only visible to invited members.
  PRIVATE,
}
