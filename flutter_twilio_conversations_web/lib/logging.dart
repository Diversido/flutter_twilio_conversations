class Logging {
  static bool dartDebug = false;

  static void debug(dynamic msg) {
    if (dartDebug) {
      print(('$msg'));
    }
  }
}
