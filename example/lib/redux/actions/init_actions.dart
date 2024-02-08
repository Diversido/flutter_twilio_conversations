import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class UpdateTokenAction {
  final String token;

  UpdateTokenAction(this.token);
}

class InitializeAction {
  final String token;

  InitializeAction(this.token);
}

class UpdateChatClient {
  final ChatClient chatClient;

  UpdateChatClient(this.chatClient);
}

class SubscribeToChatClientSyncAction {}

class SubscribeToConversationsUpdatesAction {}

class SubscribeToMembersTypingStatus {
  final Channel channel;

  SubscribeToMembersTypingStatus(this.channel);
}

class UpdateIndicatorsAction {
  final bool? isTwilioInitializing;
  final bool? isClientSyncing;

  UpdateIndicatorsAction({this.isTwilioInitializing, this.isClientSyncing});
}

class UpdateDialogsAction {
  final List<ConversationDialog> dialogs;

  UpdateDialogsAction(this.dialogs);
}
