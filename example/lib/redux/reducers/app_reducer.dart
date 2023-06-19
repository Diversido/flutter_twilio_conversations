import 'package:flutter_twilio_conversations_example/redux/actions/channel_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/init_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/messages_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations_example/utils/nullable.dart';

class AppReducer extends ReducerClass<AppState> {
  @override
  AppState call(AppState state, action) => combineReducers<AppState>(
        [
          TypedReducer(_updateTwilioToken),
          TypedReducer(_updateChatClient),
          TypedReducer(_updateIndicators),
          TypedReducer(_updateConversation),
          TypedReducer(_updateChatMessages),
          TypedReducer(_openConversation),
          TypedReducer(_closeConversation),
          TypedReducer(_typingStarted),
          TypedReducer(_typingEnded),
        ],
      )(state, action);

  AppState _updateTwilioToken(
    AppState state,
    UpdateTokenAction action,
  ) =>
      state.copyWith(
          twilioToken: action.token,
          navigationState: state.navigationState.copyWith(
            isAuthorized: true,
          ));

  AppState _updateChatClient(
    AppState state,
    UpdateChatClient action,
  ) =>
      state.copyWith(chatClient: Nullable(action.chatClient));

  AppState _updateIndicators(
    AppState state,
    UpdateIndicatorsAction action,
  ) =>
      state.copyWith(
        isTwilioInitializing: action.isTwilioInitializing,
        isClientSyncing: action.isClientSyncing,
      );

  AppState _updateConversation(
    AppState state,
    UpdateDialogsAction action,
  ) =>
      state.copyWith(dialogs: action.dialogs);

  AppState _updateChatMessages(
    AppState state,
    UpdateChatMessagesAction action,
  ) =>
      action.messages.isNotEmpty
          ? state.copyWith(
              dialogs: state.dialogs
                  .map((dialog) =>
                      dialog.channel.sid == action.messages.first.channelSid
                          ? dialog.copyWith(messages: action.messages)
                          : dialog)
                  .toList(),
              selectedDialog: state.selectedDialog?.channel.sid ==
                      action.messages.first.channelSid
                  ? Nullable(
                      state.selectedDialog?.copyWith(messages: action.messages))
                  : Nullable(state.selectedDialog),
            )
          : state;

  AppState _openConversation(
    AppState state,
    OpenConversationAction action,
  ) =>
      state.copyWith(
        selectedDialog: Nullable(action.dialog),
        navigationState: state.navigationState.copyWith(isDialogOpened: true),
      );

  AppState _typingStarted(
    AppState state,
    TypingStarted action,
  ) =>
      state.copyWith(
        dialogs: state.dialogs
            .map((dialog) => dialog.channel.sid == action.event.channel.sid
                ? dialog.addTypingMember(action.event.member)
                : dialog)
            .toList(),
        selectedDialog:
            state.selectedDialog?.channel.sid == action.event.channel.sid
                ? Nullable(
                    state.selectedDialog?.addTypingMember(action.event.member),
                  )
                : Nullable(state.selectedDialog),
      );

  AppState _typingEnded(
    AppState state,
    TypingEnded action,
  ) =>
      state.copyWith(
        dialogs: state.dialogs
            .map((dialog) => dialog.channel.sid == action.event.channel.sid
                ? dialog.removeTypingMember(action.event.member)
                : dialog)
            .toList(),
        selectedDialog: state.selectedDialog?.channel.sid ==
                action.event.channel.sid
            ? Nullable(
                state.selectedDialog?.removeTypingMember(action.event.member),
              )
            : Nullable(state.selectedDialog),
      );

  AppState _closeConversation(
    AppState state,
    CloseConversationAction action,
  ) =>
      state.copyWith(
        selectedDialog: Nullable(null),
        navigationState: state.navigationState.copyWith(isDialogOpened: false),
      );
}
