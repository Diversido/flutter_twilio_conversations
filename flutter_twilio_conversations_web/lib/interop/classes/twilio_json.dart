import 'package:js/js.dart';

@JS('Twilio.JSONValue')
class JSONValue {
  external dynamic get NULL;
  external dynamic get string;
  external dynamic get number;
  external dynamic get boolean;
  external dynamic get JSONObject;
  external dynamic get JSONArray;
}

@JS('Twilio.JSONObject')
class JSONObject {
  external dynamic get value;
}
