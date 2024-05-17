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
  Future<dynamic> create(String token, Properties properties) async {
    // TODO Nic check that properties can be dynamic
    return _methodChannel.invokeMethod('create',
        <String, Object>{'token': token, 'properties': properties.toMap()});
  }

  Future<Map<dynamic, dynamic>> createChannel(String friendlyName, String channelType) async {
    return await _methodChannel.invokeMethod(
        'Channels#createChannel', <String, Object>{
      'friendlyName': friendlyName,
      'channelType': channelType
    });
  }

// TODO Nic see if dynamic doesn't need to be returned
  Future<dynamic> getChannel(String channelSidOrUniqueName) {
    return _methodChannel.invokeMethod('Channels#getChannel',
        <String, Object>{'channelSidOrUniqueName': channelSidOrUniqueName});
  }

// needs to be implemented for the mobile interface
  Stream<Map<String,dynamic>>? chatClientStream() {}
}
