import 'package:flutter/foundation.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/init_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/messages_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

class TwilioMiddleware extends EpicMiddleware<AppState> {
  TwilioMiddleware()
      : super(combineEpics([
          _initTwilio(),
          _sendTextMessage(),
          _sendImage(),
        ]));

  static Epic<AppState> _initTwilio() => TypedEpic((
        Stream<InitializeAction> stream,
        EpicStore<AppState> store,
      ) =>
          stream.asyncExpand((action) async* {
            try {
              yield UpdateIndicatorsAction(isTwilioInitializing: true);

              final chatClient = await TwilioConversationsClient.create(
                  action.token, Properties());

              if (chatClient != null) {
                yield UpdateChatClient(chatClient);
                yield UpdateTokenAction(action.token);
                debugPrint('Successfully initialized Twilio ChatClient');
                yield UpdateIndicatorsAction(isClientSyncing: true);
                yield UpdateIndicatorsAction(isTwilioInitializing: false);
                yield SubscribeToChatClientSyncAction();
              } else {
                debugPrint('ChatClient is null, parsing error');
                yield UpdateIndicatorsAction(isTwilioInitializing: false);
              }
            } catch (e) {
              debugPrint('Failed to load chatClient: $e');
              yield UpdateIndicatorsAction(isTwilioInitializing: false);
            }
          }));

  static Epic<AppState> _sendTextMessage() => TypedEpic((
        Stream<SendTextMessageAction> stream,
        EpicStore<AppState> store,
      ) =>
          stream.asyncExpand((action) async* {
            try {
              final request =
                  await action.channel.messages?.sendMessage(MessageOptions()
                    ..withBody(action.text)
                    ..withAttributes({'customKey': 'customValue'}));

              if (request != null) {
                debugPrint(
                  'TwilioLog --- message sent to ${action.channel}: ${request.messageBody}',
                );
              } else {
                yield ShowToastAction('Failed to send message');
              }
            } catch (e) {
              debugPrint('Error while sending message: $e');
            }
          }));

  static Epic<AppState> _sendImage() => TypedEpic((
        Stream<SendImageAction> stream,
        EpicStore<AppState> store,
      ) =>
          stream.asyncExpand((action) async* {
            try {
              final request = await action.channel.messages?.sendMessage(
                MessageOptions()
                  ..withMedia(
                    action.image,
                    action.image.path.toLowerCase().endsWith('heic')
                        ? 'image/heic'
                        : 'image/jpeg',
                  ),
              );

              if (request != null) {
                debugPrint('TwilioLog --- image sent to ${action.channel}');
              } else {
                yield ShowToastAction('Failed to send image');
              }
            } catch (e) {
              debugPrint('Error while sending image: $e');
            }
          }));
}
