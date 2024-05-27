import 'dart:io';

import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/channel_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/init_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/messages_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class MessengerSubscriptionsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is SubscribeToChatClientSyncAction) {
      handleChatSyncSubscription(store, action);
    } else if (action is GetConversationMessagesAction) {
      getConversationMessages(store, action);
    } else if (action is SubscribeToConversationsUpdatesAction) {
      handleNewMessagesSubscription(store, action);
    } else if (action is SubscribeToMembersTypingStatus) {
      handleTypingStatusSubscription(store, action);
    }

    next(action);
  }

  void handleChatSyncSubscription(
    Store<AppState> store,
    SubscribeToChatClientSyncAction action,
  ) {
    if (store.state.chatClient != null) {
      store.state.chatClient?.onClientSynchronization?.listen((event) async {
        print('Client synchronized');
        // in Android there is a separate event to identify when fully initialized
        // in iOS we do check manually
        if (event == ChatClientSynchronizationStatus.CONVERSATIONS_COMPLETED ||
            (event == ChatClientSynchronizationStatus.COMPLETED &&
                store.state.chatClient?.channels != null
            // && Platform.isIOS // TODO check this as android is sending completed when chatclient already exists
            // possibly another call should invoke this reload
            )) {
          final dialogs = store.state.chatClient!.channels!.subscribedChannels
              .map(
                (channel) =>
                    ConversationDialog(channel: channel, name: channel.sid),
              )
              .toList();

          store.dispatch(
            UpdateDialogsAction(
              dialogs,
            ),
          );

          for (var conversation
              in store.state.chatClient!.channels!.subscribedChannels) {
            store.dispatch(GetConversationMessagesAction(conversation));
            store.dispatch(SubscribeToMembersTypingStatus(conversation));
          }

          store.dispatch(
            UpdateIndicatorsAction(
              isClientSyncing: false,
            ),
          );

          store.dispatch(SubscribeToConversationsUpdatesAction());
        }
      });
    }
  }

  void handleTypingStatusSubscription(
    Store<AppState> store,
    SubscribeToMembersTypingStatus action,
  ) {
    try {
      action.channel.onTypingStarted?.listen((event) {
        print('Typing started: $event');
        store.dispatch(TypingStarted(event));
      });

      action.channel.onTypingEnded?.listen((event) {
        print('Typing ended: $event');
        store.dispatch(TypingEnded(event));
      });
    } catch (e) {
      print('Failed to handleTypingStatusSubscription: $e');
    }
  }

  void handleNewMessagesSubscription(
    Store<AppState> store,
    SubscribeToConversationsUpdatesAction action,
  ) {
    if (store.state.chatClient != null) {
      store.state.chatClient?.onChannelUpdated?.listen((event) async {
        print('New conversation event: $event');

        if (event.reason != ChannelUpdateReason.LAST_CONSUMED_MESSAGE_INDEX) {
          store.dispatch(GetConversationMessagesAction(event.channel));
        }

        store.dispatch(ShowLocalNotification('Test', 'Test'));
      });
    }
  }

  void getConversationMessages(
    Store<AppState> store,
    GetConversationMessagesAction action,
  ) async {
    if (action.channel.synchronizationStatus ==
        ChannelSynchronizationStatus.ALL) {
      try {
        final messages = await action.channel.messages?.getLastMessages(50);

        print('Got messages: $messages');
        if (messages != null) {
          store.dispatch(UpdateChatMessagesAction(messages));
        }
      } catch (e) {
        print('Failed to get messages: $e');
      }
    } else {
      print('Started listening to an unsynced channel');
      action.channel.onSynchronizationChanged?.listen((channel) async {
        print('Channel sync event: ${channel.synchronizationStatus}');
        if (channel.synchronizationStatus == ChannelSynchronizationStatus.ALL) {
          try {
            final messages = await action.channel.messages?.getLastMessages(50);

            print('Got messages: $messages');
            if (messages != null) {
              store.dispatch(UpdateChatMessagesAction(messages));
            }
          } catch (e) {
            print('Failed to get messages: $e');
          }
        }
      });
    }
  }
}
