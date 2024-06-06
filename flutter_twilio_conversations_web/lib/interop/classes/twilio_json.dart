import 'package:js/js.dart';

@JS('Twilio.Conversations.JSONValue')
class JSONValue {
  external dynamic string;
  external dynamic type;
  external dynamic get number;
  external dynamic get boolean;
  external dynamic get JSONObject;
  external dynamic get JSONArray;
  external dynamic get value;
}

@JS('Twilio.JSONObject')
class JSONObject {
  external dynamic get value;
}
