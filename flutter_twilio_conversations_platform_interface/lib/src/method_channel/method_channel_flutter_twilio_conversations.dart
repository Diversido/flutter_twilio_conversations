import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:meta/meta.dart';
import '../platform_interface/flutter_twilio_conversations_platform.dart';

// const MethodChannel _channel =
//     MethodChannel('plugins.flutter.io/flutter_twilio_conversations');

/// An implementation of [FlutterTwilioConversationsPlatform] that uses method channels.
class MethodChannelFlutterTwilioConversations
    extends FlutterTwilioConversationsPlatform {
  // @visibleForTesting
  // MethodChannel get channel => _channel;
  final MethodChannel _methodChannel;

  MethodChannelFlutterTwilioConversations()
      : _methodChannel = MethodChannel('flutter_twilio_conversations'),
        super();

  /// This constructor is only used for testing and shouldn't be accessed by
  /// users of the plugin. It may break or change at any time.
  @visibleForTesting
  MethodChannelFlutterTwilioConversations.private(
    this._methodChannel,
  );

  @override
  Future<ChatClient?> create(String token, Properties properties) async {
    return _methodChannel.invokeMethod("create");
  }

// needs to be implemented for the mobile interface
  Stream<BaseChatClientEvent>? chatClientStream() {}
}
