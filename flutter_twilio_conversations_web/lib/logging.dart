import 'package:flutter/foundation.dart';

class Logging {
  static void debug(dynamic msg) {
    if (kDebugMode) print(('$msg'));
  }
}
