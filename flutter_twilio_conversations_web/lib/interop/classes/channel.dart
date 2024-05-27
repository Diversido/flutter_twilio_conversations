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
