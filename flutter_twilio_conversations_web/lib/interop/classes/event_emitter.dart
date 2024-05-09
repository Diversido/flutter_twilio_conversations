@JS()
library event_emitter;

import 'package:js/js.dart';

@JS()
class EventEmitter {
  external dynamic on(String eventName, Function listener);
  external dynamic off(String eventName, Function listener);

  external factory EventEmitter();
}
