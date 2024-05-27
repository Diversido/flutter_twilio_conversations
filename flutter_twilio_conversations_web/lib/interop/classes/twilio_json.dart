import 'package:js/js.dart';

@JS('Twilio.JSONValue')
class JSONValue {
  external dynamic get value;
}