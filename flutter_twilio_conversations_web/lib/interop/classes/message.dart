// Define Twilio.Conversations.Client class
import 'package:js/js.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';

@JS('Twilio.Conversations.Message')
class TwilioConversationsMessage {
  external dynamic get updated;
}

extension Interop on TwilioConversationsMessage {
  MessageModel toModel() {
    return MessageModel(
      updated: updated,
    );
  }
}
