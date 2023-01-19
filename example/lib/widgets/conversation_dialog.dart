import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

class ConversationDialog {
  final Channel channel;
  final String? name;
  final List<Message> messages;
  final bool isConversationSyncing;

  ConversationDialog({
    required this.channel,
    this.name,
    this.messages = const [],
    this.isConversationSyncing = false,
  });

  String get title => name != null && name!.isNotEmpty ? name! : channel.sid;

  String? get lastMessageText =>
      messages.isNotEmpty ? messages.last.messageBody : null;

  ConversationDialog copyWith({
    Channel? channel,
    List<Message>? messages,
    bool? isConversationSyncing,
  }) =>
      ConversationDialog(
        channel: channel ?? this.channel,
        messages: messages ?? this.messages,
        isConversationSyncing:
            isConversationSyncing ?? this.isConversationSyncing,
      );
}
