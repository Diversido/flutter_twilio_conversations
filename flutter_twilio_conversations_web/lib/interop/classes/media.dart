import 'package:js/js.dart';

@JS('Twilio.Conversations.Media')
class TwilioConversationsMedia {
  external String sid;
  external String fileName;
  external String contentType;
  external int size;

}
