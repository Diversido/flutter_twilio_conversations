
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

/// Model that a plugin implementation can use to construct a ChatClient.
class ClientModel {
  final ConnectionState connectionState;
  final String version;


  const ClientModel({
    required this.connectionState,
    required this.version,
  });

  @override
  String toString() {
    return '{ connectionState: $connectionState, version: $version }';
  }
}
