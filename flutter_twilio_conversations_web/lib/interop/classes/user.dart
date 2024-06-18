import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:js/js.dart';

@JS('Twilio.Conversations.User')
class TwilioConversationsUser {
  external factory TwilioConversationsUser();

  external String get identity;
  external Attributes? get attributes;
  external String? get friendlyName;
  external bool? get isNotifiable;
  external bool? get isOnline;
  external bool? get isSubscribed;
}
