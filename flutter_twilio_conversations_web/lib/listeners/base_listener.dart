import 'package:flutter/foundation.dart';

abstract class BaseListener {
  void debug(String msg) {
    if (kDebugMode) print(('Listener Event: $msg'));
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }
}
