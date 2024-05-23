// Define Twilio.Conversations.Client class
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/last_message.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/twilio_json.dart';
import 'package:js/js.dart';

@JS('Twilio.Conversations.Conversation')
class TwilioConversationsChannel extends EventEmitter {
  external factory TwilioConversationsChannel();
  external String get sid;
  external JSONValue? get attributes;
  external LastMessage lastMessage;
  external DateTime? dateCreated;
  external String? createdBy;
  external ChannelStatus status;
  external ChannelSynchronizationStatus synchronizationStatus;
  external DateTime dateCreatedAsDate;
  external DateTime dateUpdated;
  external DateTime lastMessageDate;
  external int lastMessageIndex;
  external int lastReadMessageIndex;

  external dynamic getMessages();
}
