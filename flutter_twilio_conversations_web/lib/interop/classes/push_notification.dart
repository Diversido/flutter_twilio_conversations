import 'package:js/js.dart';

@JS('Twilio.Conversations.PushNotification')
class PushNotification {
  external String? action;
  external int? badge;
  external String? body;
  external PushNotificationData? data;
  external String? sound;
  external String? title;

  /// "twilio.conversations.new_message" | "twilio.conversations.added_to_conversation" | "twilio.conversations.removed_from_conversation"
  external String? type;
}

@JS('Twilio.Conversations.PushNotificationData')
class PushNotificationData {
  external String? conversationSid;
  external int? messageIndex;
  external String? messageSid;
}
