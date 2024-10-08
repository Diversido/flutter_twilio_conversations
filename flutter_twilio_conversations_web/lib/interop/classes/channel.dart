import 'package:flutter_twilio_conversations_web/interop/classes/conversation_state.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/last_message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/message_builder.dart';
import 'package:js/js.dart';

@JS('Twilio.Conversations.Conversation')
class TwilioConversationsChannel extends EventEmitter {
  external factory TwilioConversationsChannel();

  external String get sid;
  external JSMap attributes;
  external String? createdBy;
  external dynamic dateCreated;
  external dynamic dateUpdated;
  external String? friendlyName;
  external LastMessage? lastMessage;
  external int? lastReadMessageIndex;
  external ConversationState? state;
  external String? status;
  external String? uniqueName;

  external dynamic getMessages(int? pageSize, int? anchor, String? direction);
  external MessageBuilder prepareMessage();
  external dynamic setAllMessagesRead();
  external dynamic getMessagesCount();
  external Future<int?> getUnreadMessagesCount();
  external Future<void> typing();
  external dynamic send();
  external dynamic getAttributes();
}
