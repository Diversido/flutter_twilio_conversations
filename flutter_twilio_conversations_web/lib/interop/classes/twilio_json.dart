import 'package:js/js.dart';

@JS('Twilio.Conversations.JSONValue')
class JSONValue {}

@JS('Twilio.JSONObject')
class JSONObject {
  external dynamic get value;
}

@JS('Twilio.JSONArray')
class JSONArray {
  external List<dynamic> get value;
}
