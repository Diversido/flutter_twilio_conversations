import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class ShowToastAction {
  final String text;

  ShowToastAction(this.text);
}

class OpenConversationAction {
  final ConversationDialog dialog;

  OpenConversationAction(this.dialog);
}

class CloseConversationAction {}

class ShowLocalNotification {
  final String title;
  final String text;

  ShowLocalNotification(this.title, this.text);
}
