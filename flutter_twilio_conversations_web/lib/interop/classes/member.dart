import 'package:js/js.dart';

import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/twilio_json.dart';

@JS('Twilio.Conversations.Participant')
class TwilioConversationsMember extends EventEmitter {
  external factory TwilioConversationsMember();

  external String sid;
  external TwilioConversationsChannel conversation;
  external String identity;
  external String channelSid;
  external String type;
  external String lastReadMessageIndex;
  external DateTime lastReadTimestamp;
  external JSONValue attributes;
}
