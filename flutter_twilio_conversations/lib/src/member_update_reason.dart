part of flutter_twilio_conversations;

/// Indicates reason for member info update.
enum MemberUpdateReason {
  /// [Member] last read message index has changed.
  LAST_CONSUMED_MESSAGE_INDEX,

  /// This update will be documented in the next SDK version.
  ATTRIBUTES,
  // Requested in https://github.com/Diversido/flutter_twilio_conversations/issues/41
  LAST_READ_TIMESTAMP,
  LAST_READ_MESSAGE_INDEX,
}
