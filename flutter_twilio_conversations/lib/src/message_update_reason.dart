part of flutter_twilio_conversations;

/// Indicates reason for message update.
enum MessageUpdateReason {
  /// [Message] body has been updated.
  BODY,

  /// [Message] attributes have been updated.
  ATTRIBUTES,

  /// [Message] lastUpdatedBy has been updated.
  LAST_UPDATED_BY,

  /// [Message] dateCreated has been updated.
  DATE_CREATED,

  /// [Message] dateUpdated has been updated.
  DATE_UPDATED,

  /// [Message] author has been updated.
  AUTHOR,

  /// [Message] deliveryReceipt has been updated.
  DELIVERY_RECEIPT,

  /// [Message] subject has been updated.
  SUBJECT,

  /// Default
  UNKNOWN,
}
