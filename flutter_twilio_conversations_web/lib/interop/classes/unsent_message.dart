import 'package:js/js.dart';

@JS('Twilio.Conversations.UnsentMessage')
class UnsentMessage {
  external factory UnsentMessage();

  /// Send the prepared message to the conversation.
  /// return index of the new message in the conversation.
  external int send();
}
