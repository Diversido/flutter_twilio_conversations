import 'package:js/js.dart';

@JS('Twilio.ConversationState')
class ConversationState {
  // The current state: "active" | "inactive" | "closed"
  external String? current;

  // Date at which the latest conversation state update happened.
  external DateTime? dateUpdated;
}
