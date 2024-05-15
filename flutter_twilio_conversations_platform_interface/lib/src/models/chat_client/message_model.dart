
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

/// Model that a plugin implementation can use to construct a ChatClient.
class MessageModel {
  final dynamic updated;


  const MessageModel({
    required this.updated,
  });

  @override
  String toString() {
    return '{ updated: $updated}';
  }
}
