import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

class ConversationDialog {
  final Channel channel;
  final String? name;
  final List<Message> messages;
  final bool isConversationSyncing;
  final List<String> typingMembers;

  ConversationDialog({
    required this.channel,
    this.name,
    this.messages = const [],
    this.isConversationSyncing = false,
    this.typingMembers = const [],
  });

  String get title => name != null && name!.isNotEmpty ? name! : channel.sid;

  String? get lastMessageText => typingMembers.isNotEmpty
      ? typingMessage()
      : messages.isNotEmpty
          ? messages.last.messageBody
          : null;

  String typingMessage() {
    if (typingMembers.isEmpty) {
      return '';
    }

    if (typingMembers.length == 1) {
      return '${typingMembers.first} is typing...';
    }

    return '${typingMembers.first} and ${typingMembers.length - 1} others are typing...';
  }

  ConversationDialog copyWith({
    Channel? channel,
    List<Message>? messages,
    bool? isConversationSyncing,
    List<String>? typingMembers,
  }) =>
      ConversationDialog(
        channel: channel ?? this.channel,
        messages: messages ?? this.messages,
        isConversationSyncing:
            isConversationSyncing ?? this.isConversationSyncing,
        typingMembers: typingMembers ?? this.typingMembers,
      );

  ConversationDialog addTypingMember(Member member) {
    if (typingMembers.contains(member.identity)) {
      return this;
    }
    return copyWith(typingMembers: [...typingMembers, member.identity ?? '']);
  }

  ConversationDialog removeTypingMember(Member member) {
    if (!typingMembers.contains(member.identity)) {
      return this;
    }
    return copyWith(
        typingMembers:
            typingMembers.where((m) => m != member.identity).toList());
  }
}
