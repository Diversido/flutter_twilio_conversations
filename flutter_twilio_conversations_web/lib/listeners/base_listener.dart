import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

abstract class BaseListener {
  void debug(String msg) {
    TwilioConversationsClient.log(('Listener Event: $msg'));
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }
}
