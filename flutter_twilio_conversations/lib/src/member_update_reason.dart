part of flutter_twilio_conversations;

/// Indicates reason for member info update.
enum MemberUpdateReason {
  /// [Member] last read message index has changed.
  LAST_CONSUMED_MESSAGE_INDEX,

  /// This update will be documented in the next SDK version.
  ATTRIBUTES,
}
