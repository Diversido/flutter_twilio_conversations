import 'package:flutter_twilio_conversations_web/interop/classes/conversation_state.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/last_message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/twilio_json.dart';
import 'package:js/js.dart';

@JS('Twilio.Conversations.Conversation')
class TwilioConversationsChannel extends EventEmitter {
  external factory TwilioConversationsChannel();

  external String get sid;
  external JSONValue? get attributes;
  external String? createdBy;
  external dynamic dateCreated;
  external dynamic dateUpdated;
  external String? friendlyName;
  external LastMessage? lastMessage;
  external int? lastReadMessageIndex;
  external ConversationState? state;
  external String? status;
  external String? uniqueName;

  external dynamic getMessages();
}


// Martin sid=CH48ec5d3342144f838c6ee7448194c88f
// Martin attributes=[object Object]
// Martin createdBy=system
// Martin dateCreated=Thu May 16 2024 17:00:59 GMT+0200 (South Africa Standard Time)
// Martin dateUpdated=Thu May 16 2024 17:00:59 GMT+0200 (South Africa Standard Time)
// Martin friendlyName=null
// Martin lastMessage=[object Object]
// Martin lastReadMessageIndex=7
// Martin state=[object Object]
// Martin status=joined
// Martin uniqueName=null