import 'package:flutter/foundation.dart';
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
    } else if (action is GetConversationUnreadMessagesCountAction) {
      getConversationUnreadMessagesCountAction(store, action);
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
        // in Android there is a separate event to identify when fully initialized
        // in iOS we do check manually
        if (event == ChatClientSynchronizationStatus.CONVERSATIONS_COMPLETED ||
            (event == ChatClientSynchronizationStatus.COMPLETED &&
                store.state.chatClient?.channels != null)) {
          final dialogs = store.state.chatClient!.channels!.subscribedChannels
              .map((channel) {
            return ConversationDialog(
              channel: channel,
              name: channel.sid,
            );
          }).toList();

          store.dispatch(UpdateDialogsAction(dialogs));

          for (var conversation
              in store.state.chatClient!.channels!.subscribedChannels) {
            store.dispatch(GetConversationMessagesAction(conversation));
            store.dispatch(
                GetConversationUnreadMessagesCountAction(conversation));
            store.dispatch(SubscribeToMembersTypingStatus(conversation));

            //Only for example purposes, print members
            final members = await conversation.members?.getMembersList();
            debugPrint('Got members: ${members?.length}');
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
        store.dispatch(TypingStarted(event));
      });

      action.channel.onTypingEnded?.listen((event) {
        store.dispatch(TypingEnded(event));
      });
    } catch (e) {
      debugPrint('Failed to handleTypingStatusSubscription: $e');
    }
  }

  void handleNewMessagesSubscription(
    Store<AppState> store,
    SubscribeToConversationsUpdatesAction action,
  ) {
    if (store.state.chatClient != null) {
      store.state.chatClient?.onChannelUpdated?.listen((event) async {
        debugPrint('New conversation event: $event');

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

        debugPrint('Got messages: $messages');
        if (messages != null) {
          store.dispatch(UpdateChatMessagesAction(messages));
        }
      } catch (e) {
        debugPrint('Failed to get messages: $e');
      }
    } else {
      debugPrint('Started listening to an unsynced channel');
      action.channel.onSynchronizationChanged?.listen((channel) async {
        debugPrint('Channel sync event: ${channel.synchronizationStatus}');
        if (channel.synchronizationStatus == ChannelSynchronizationStatus.ALL) {
          try {
            final messages = await action.channel.messages?.getLastMessages(50);

            debugPrint('Got messages: $messages');
            if (messages != null) {
              store.dispatch(UpdateChatMessagesAction(messages));
            }
          } catch (e) {
            debugPrint('Failed to get messages: $e');
          }
        }
      });
    }
  }

  void getConversationUnreadMessagesCountAction(
    Store<AppState> store,
    GetConversationUnreadMessagesCountAction action,
  ) async {
    if (action.channel.synchronizationStatus ==
        ChannelSynchronizationStatus.ALL) {
      try {
        final count = await action.channel.getUnreadMessagesCount();
        if (count != null) {
          store.dispatch(
            UpdateUnreadMessagesCountAction(action.channel, count),
          );
        }
      } catch (e) {
        debugPrint('Failed to get messages: $e');
      }
    }
  }
}
