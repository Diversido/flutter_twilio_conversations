// Define Twilio.Conversations.Client class
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:js/js.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';

@JS('Twilio.Conversations.Media')
class TwilioConversationsMedia {
  external String sid;
  external String fileName;
  external String type;
  external DateTime size;
  external String channelSid;
  external String _messageIndex;
}

// extension Interop on TwilioConversationsMedia {
//   MessageModel toModel() {
//     return MessageModel(
//       updated: updated,
//     );
//   }
// }
