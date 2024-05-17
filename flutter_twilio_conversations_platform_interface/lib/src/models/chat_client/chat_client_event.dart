import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_platform_interface/src/models/model_exports.dart';

/// The base RoomEvent that all other RoomEvent types must extend.
abstract class BaseChatClientEvent {
  final ConnectionState? connectionState;

  const BaseChatClientEvent(this.connectionState);

  @override
  String toString() =>
      'BaseChatClientEvent: { connectionState: $connectionState }';
}

class ConnectionStateChange extends BaseChatClientEvent {
  // final TwilioException? exception;

  const ConnectionStateChange(
    ConnectionState connectionState,
    // this.exception,
  ) : super(connectionState);

  Map<String, dynamic> toJson() {
    return {
      'name' : 'ConnectionStateChange',
      'connectionState': connectionState,
      // 'exception': exception,
    };
  }
}

class ChannelAdded extends BaseChatClientEvent {
  final String name;
  final ChannelModel? channel;

  const ChannelAdded(ConnectionState connectionState, this.name, this.channel)
      : super(connectionState);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'channel': channel,
    };
  }

  @override
  String toString() => 'ChannelAdded: {eventName: $name, channel: $channel}';


}

/// Use this event if connecting to a Room failed.
class ConnectError extends BaseChatClientEvent {
  // final TwilioException? exception;
  final String error;

  const ConnectError(
    ConnectionState connectionState,
    this.error,
    // this.exception,
  ) : super(connectionState);

  @override
  String toString() => 'ConnectError: { chatClientModel: $error, exception:  }';
}
