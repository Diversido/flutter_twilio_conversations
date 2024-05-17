// Define Twilio.Conversations.Client class
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:js/js.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';

//@JS('Twilio.Conversations.Channel')
@JS('Twilio.Conversations.Conversation')
class TwilioConversationsChannel {
  external String get sid;
  external Map<dynamic, dynamic>? get attributes;
  external DateTime? _dateCreated;
  external String? _createdBy;
  external ChannelStatus status;
  external ChannelSynchronizationStatus synchronizationStatus;
  external DateTime dateCreatedAsDate;
  external String createdBy;
  external DateTime dateUpdatedAsDate;
  external DateTime lastMessageDate; // LastMessage - date and index
  external int lastMessageIndex;
  external int lastReadMessageIndex;

  external dynamic getMessagesA();
}

extension Interop on TwilioConversationsChannel {
  ChannelModel toModel() {
    return ChannelModel(
      sid: sid,
      attributes: attributes,
      dateCreated: _dateCreated,
      createdBy: _createdBy,
    );
  }
}
