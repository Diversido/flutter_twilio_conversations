/// Representation of a Chat Error Object.
class ErrorInfo implements Exception {
  //#region Error codes
  /// This status is set if error occurred in the SDK and is not related to network operations.
  static const int CLIENT_ERROR = 0;

  /// This code is used by [Messages.getMessageByIndex] if general error occurs and message could not be retrieved.
  static const int CANNOT_GET_MESSAGE_BY_INDEX = -4;

  /// This code is used by [ChatClient.updateToken] if updated token does not match the original token.
  ///
  /// This error often indicates that you have updated token with a different identity, which is not allowed - you cannot change client identity mid-flight.
  /// If this error is returned, you should shutdown and re-create ChatClient.
  static const int MISMATCHING_TOKEN_UPDATE = -5;

  /// This code is signaled when an attempt is made to query channel members or messages without synchronizing first.
  static const int CHANNEL_NOT_SYNCHRONIZED = -6;
  //#endregion

  /// Code indicator, should match any of the [ErrorInfo] static properties.
  final int? code;

  /// Message containing a short explanation.
  final String? message;

  /// Get error category as a classifier.
  ///
  /// Local client errors get status 0, network related errors have their HTTP error code as a status.
  final int? status;

  ErrorInfo(this.code, this.message, this.status)
      : assert(code != null),
        assert(message != null);

  @override
  String toString() {
    return 'ErrorInfo: code: $code, message: $message, status: $status';
  }
}
