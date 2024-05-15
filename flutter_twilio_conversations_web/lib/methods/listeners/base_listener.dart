

abstract class BaseListener {
  // Should be overridden by all subclasses.
  void debug(String msg) {
    print('Listener Event: $msg');
  }

  // Helper for debug statements
  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }
}
