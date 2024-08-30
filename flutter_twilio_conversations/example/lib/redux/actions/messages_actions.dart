import 'dart:io';

import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

class GetConversationMessagesAction {
  final Channel channel;

  GetConversationMessagesAction(this.channel);
}

class GetConversationUnreadMessagesCountAction {
  final Channel channel;

  GetConversationUnreadMessagesCountAction(this.channel);
}

class UpdateChatMessagesAction {
  final List<Message> messages;

  UpdateChatMessagesAction(this.messages);
}

class UpdateUnreadMessagesCountAction {
  final Channel channel;
  final int unreadMessagesCount;

  UpdateUnreadMessagesCountAction(this.channel, this.unreadMessagesCount);
}

class SendTextMessageAction {
  final Channel channel;
  final String text;

  SendTextMessageAction(this.channel, this.text);
}

class SendImageAction {
  final Channel channel;
  final File image;

  SendImageAction(this.channel, this.image);
}

class SendTypingAction {
  final Channel channel;

  SendTypingAction(this.channel);
}
