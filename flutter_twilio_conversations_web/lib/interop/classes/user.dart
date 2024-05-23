// Define Twilio.Conversations.Client class
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:js/js.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';

@JS('Twilio.Conversations.User')
class TwilioConversationsUser {
  external String get identity;
  external Attributes? get attributes;
  external String? get friendlyName;
}

extension Interop on TwilioConversationsUser {
  UserModel toModel() {
    return UserModel(
      identity: identity,
      attributes: attributes,
      friendlyName: friendlyName,
    );
  }
}
