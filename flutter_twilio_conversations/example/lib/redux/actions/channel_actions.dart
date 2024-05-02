import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

class TypingStarted {
  final TypingEvent event;

  TypingStarted(this.event);
}

class TypingEnded {
  final TypingEvent event;

  TypingEnded(this.event);
}
