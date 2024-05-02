import 'dart:async';

import 'package:flutter/services.dart';

import 'flutter_twilio_conversations_platform_interface.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.io/flutter_twilio_conversations');

/// An implementation of [FlutterTwilioConversationsPlatform] that uses method channels.
class MethodChannelFlutterTwilioConversations extends FlutterTwilioConversationsPlatform {
  @override
  Future<bool> launch(String url) {
    return _channel.invokeMethod<bool>(
      'launch',
      <String, Object>{
        'url': url,
      },
    );
  }
}