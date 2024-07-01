part of flutter_twilio_conversations;

/// Indicates synchronization status for channel.
enum ChannelSynchronizationStatus {
  /// [Channel] collections: members, messages can be fetched.
  ALL,

  /// [Channel] synchronization failed.
  FAILED,

  /// [Channel] SID, not synchronized with cloud.
  IDENTIFIER,

  /// [Channel] metadata: friendly name, channel SID, attributes, unique name.
  METADATA,

  /// Local copy, does not exist in cloud.
  NONE,
}
