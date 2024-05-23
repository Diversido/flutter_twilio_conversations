import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:js/js.dart';

@JS('Twilio.Conversations.User')
class TwilioConversationsUser {
  external String get identity;
  external Attributes? get attributes;
  external String? get friendlyName;
}
