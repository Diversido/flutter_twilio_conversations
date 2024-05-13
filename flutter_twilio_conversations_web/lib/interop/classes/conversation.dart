// Define Twilio.Conversations.Client class
import 'package:js/js.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';

@JS('Twilio.Conversations.Conversation')
class TwilioConversationsConversation {
  external String get sid;

  external dynamic getMessages();
}

extension Interop on TwilioConversationsConversation {
  ConversationModel toModel() {
    return ConversationModel(
      sid: sid,
    );
  }
}
