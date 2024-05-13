
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

/// Model that a plugin implementation can use to construct a ChatClient.
class ConversationModel {
  final String sid;


  const ConversationModel({
    required this.sid,
  });

  @override
  String toString() {
    return '{ sid: $sid}';
  }
}
