part of flutter_twilio_conversations;

/// Entry point for the Twilio Programmable Dart.
class TwilioConversationsClient extends FlutterTwilioConversationsPlatform {
  // static const MethodChannel _methodChannel =
  //     MethodChannel('flutter_twilio_conversations');

  // static const EventChannel _chatChannel =
  //     EventChannel('flutter_twilio_conversations/room');

  static const EventChannel _mediaProgressChannel =
      EventChannel('flutter_twilio_conversations/media_progress');

  static const EventChannel _loggingChannel =
      EventChannel('flutter_twilio_conversations/logging');

  // static const EventChannel _notificationChannel =
  //     EventChannel('flutter_twilio_conversations/notification');

  static StreamSubscription? _loggingStream;

  static bool _dartDebug = false;

  static ChatClient? chatClient;

  static Exception _convertException(PlatformException err) {
    var code = int.tryParse(err.code);
    // If code is an integer, then it is a Twilio ErrorInfo exception.
    if (code != null) {
      return ErrorInfo(int.parse(err.code), err.message, err.details as int);
    }

    // For now just rethrow the PlatformException. But we could make custom ones based on the code value.
    // code can be:
    // - "ERROR" Something went wrong in the custom native code.
    // - "IllegalArgumentException" Something went wrong calling the twilio SDK.
    // - "JSONException" Something went wrong parsing a JSON string.
    // - "MISSING_PARAMS" Missing params, only the native debug method uses this at the moment.
    return err;
  }

  /// Internal logging method for dart.
  static void _log(dynamic msg) {
    if (_dartDebug) {
      print('[   DART   ] $msg');
    }
  }

  /// Enable debug logging.
  ///
  /// For native logging set [native] to `true` and for dart set [dart] to `true`.
  // static Future<void> debug({
  //   bool dart = false,
  //   bool native = false,
  //   bool sdk = false,
  // }) async {
  //   _dartDebug = dart;
  //   await _methodChannel.invokeMethod('debug', {'native': native, 'sdk': sdk});
  //   if (native && _loggingStream == null) {
  //     _loggingStream =
  //         _loggingChannel.receiveBroadcastStream().listen((dynamic event) {
  //       if (native) {
  //         print('[  NATIVE  ] $event');
  //       }
  //     });
  //   } else if (!native && _loggingStream != null) {
  //     await _loggingStream?.cancel();
  //     _loggingStream = null;
  //   }
  // }

  /// Create to a [ChatClient].
  Future<ChatClient?> create(String token, Properties properties) async {
    assert(token != '');

    try {
      print('TwilioConversationsPlugin.create => starting request in Dart');
      final methodData = await FlutterTwilioConversationsPlatform.instance
          .create(token, properties);

      print('TwilioConversationsPlugin.create => finished request in Dart');
      print(methodData);
      final chatClientMap = Map<String, dynamic>.from(methodData as Map);
      print('chat client mapped: $chatClientMap');
      chatClient = ChatClient._fromMap(chatClientMap); //TODO Martin create
      print("returning chat client");
      return chatClient;
    } on PlatformException catch (err) {
      print('TwilioConversationsPlugin.create => failed in Dart');
      throw TwilioConversationsClient._convertException(err);
    }
  }
}
