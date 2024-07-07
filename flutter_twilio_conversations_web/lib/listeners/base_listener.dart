import 'package:flutter_twilio_conversations_web/logging.dart';

abstract class BaseListener {
  void debug(String msg) {
    Logging.debug('Listener Event: $msg');
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }
}
