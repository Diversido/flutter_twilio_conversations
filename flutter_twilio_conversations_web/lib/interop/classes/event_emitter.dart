@JS()
library event_emitter;

import 'package:js/js.dart';

@JS()
class EventEmitter {
  external dynamic on(String eventName, Function listener);
  external dynamic off(String eventName, Function listener);

  external factory EventEmitter();
}


/*Event Emission: Verify that the ConnectionStateChange 
events are being emitted by the Twilio Conversations chat client. If the events are
 not emitted when the connection state changes, the event handler will not be invoked, 
 even if it is correctly registered. */