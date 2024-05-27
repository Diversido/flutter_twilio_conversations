import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

/// Model that a plugin implementation can use to construct a ChatClient.
class ClientModel {
  final ConnectionState connectionState;

  //#region Private API properties
  final Channels? channels;

  final String? myIdentity;

  final Users? users;

  final bool? isReachabilityEnabled;

  const ClientModel({
    required this.connectionState,
    required this.channels,
    required this.myIdentity,
    required this.users,
    required this.isReachabilityEnabled,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "connectionState": connectionState,
      "channels": channels,
      "myIdentity": myIdentity == null ? "" : myIdentity,
      "users": users,
      "isReachabilityEnabled": isReachabilityEnabled,
    };
  }
}
