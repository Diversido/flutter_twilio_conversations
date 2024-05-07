part of flutter_twilio_conversations;

/// Represents options when connecting to a [ChatClient].
class Properties {
  //#region Private API properties
  String? _region;
  //#endregion

  //#region Public API properties
  /// Twilio server region to connect to.
  ///
  /// Instances exist in specific regions, so this should only be changed if needed.
  String? get region {
    return _region;
  }
  //#endregion

  Properties({
    String? region,
  }) {
    _region = region ?? 'us1';
  }

  /// Create map from properties.
  Map<String, Object> toMap() {
    return {'region': _region!};
  }
}
