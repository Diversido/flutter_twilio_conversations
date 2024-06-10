
import 'package:js/js.dart';

@JS('Twilio.Conversations.Media')
class TwilioConversationsMedia {
  external String sid;
  external String fileName;
  external String type;
  external DateTime size;
  external String channelSid;
}