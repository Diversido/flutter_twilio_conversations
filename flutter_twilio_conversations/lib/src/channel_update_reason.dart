part of flutter_twilio_conversations;

/// Indicates reason for channel update.
enum ChannelUpdateReason {
  /// [Channel] attributes changed.
  ATTRIBUTES,

  /// [Channel] friendly name changed.
  FRIENDLY_NAME,

  /// [Channel] last read message changed.
  LAST_CONSUMED_MESSAGE_INDEX,

  /// Last message in channel changed.
  ///
  /// This update does not trigger when message itself changes, there's [MessageUpdateReason] event for that.
  /// However, if a new message is added or last channel message is deleted this event will be triggered.
  LAST_MESSAGE,

  /// Notification leven changed.
  NOTIFICATION_LEVEL,

  /// [Channel] status changed.
  STATUS,

  /// [Channel] unique name changed.
  UNIQUE_NAME,
}
