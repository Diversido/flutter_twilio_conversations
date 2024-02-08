import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_example/redux/states/navigation_state.dart';
import 'package:flutter_twilio_conversations_example/utils/nullable.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class AppState {
  NavigationState navigationState;
  final String? twilioToken;
  final ChatClient? chatClient;

  final bool isTwilioInitializing;
  final bool isClientSyncing;
  final List<ConversationDialog> dialogs;
  final ConversationDialog? selectedDialog;

  AppState({
    required this.navigationState,
    this.twilioToken,
    this.chatClient,
    this.isTwilioInitializing = false,
    this.isClientSyncing = false,
    this.dialogs = const [],
    this.selectedDialog,
  });

  AppState.initial()
      : navigationState = NavigationState.initial(),
        twilioToken = null,
        chatClient = null,
        isTwilioInitializing = false,
        isClientSyncing = false,
        dialogs = const [],
        selectedDialog = null;

  AppState copyWith({
    NavigationState? navigationState,
    String? twilioToken,
    Nullable<ChatClient>? chatClient,
    bool? isTwilioInitializing,
    bool? isClientSyncing,
    List<ConversationDialog>? dialogs,
    Nullable<ConversationDialog>? selectedDialog,
  }) =>
      AppState(
        navigationState: navigationState ?? this.navigationState,
        twilioToken: twilioToken ?? this.twilioToken,
        chatClient: chatClient == null ? this.chatClient : chatClient.value,
        isTwilioInitializing: isTwilioInitializing ?? this.isTwilioInitializing,
        isClientSyncing: isClientSyncing ?? this.isClientSyncing,
        dialogs: dialogs ?? this.dialogs,
        selectedDialog:
            selectedDialog == null ? this.selectedDialog : selectedDialog.value,
      );
}
