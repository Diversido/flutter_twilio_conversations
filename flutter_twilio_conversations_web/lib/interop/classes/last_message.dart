import 'package:js/js.dart';

@JS('Twilio.LastMessage')
class LastMessage {
  external DateTime dateCreated;
  external int index;
}
