
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

/// Model that a plugin implementation can use to construct a ChatClient.
class ChatClientModel {
  final ConnectionState connectionState;
  final String myIdentity;
  final Users users;
  final bool isReachabilityEnabled;

  const ChatClientModel({
    required this.connectionState,
    required this.myIdentity,
    required this.users,
    required this.isReachabilityEnabled,
  });

  @override
  String toString() {
    return '{ connectionState: $connectionState, myIdentity: $myIdentity, users: $users, isReachabilityEnabled: $isReachabilityEnabled }';
  }
}
