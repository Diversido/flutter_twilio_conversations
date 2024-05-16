// Define Twilio.Conversations.Client class
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:js/js.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';

//@JS('Twilio.Conversations.Channel')
@JS('Twilio.Conversations.Conversation')
class TwilioConversationsChannel {
  external String get sid;
  external Attributes? get attributes;
  external DateTime? _dateCreated;
  external String? _createdBy;



  external dynamic getMessages();
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
