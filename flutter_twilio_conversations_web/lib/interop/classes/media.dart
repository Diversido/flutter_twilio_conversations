import 'package:js/js.dart';

@JS('Twilio.Conversations.Media')
class TwilioConversationsMedia {
  external String sid;
  external String filename;
  external String contentType;
  external int size;

  external dynamic getCachedTemporaryUrl();
  external dynamic getContentTemporaryUrl();
}
