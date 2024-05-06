import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';

class UiMiddleware extends EpicMiddleware<AppState> {
  UiMiddleware()
      : super(combineEpics([
          _showToast(),
          _showLocalNotification(),
        ]));

  static Epic<AppState> _showToast() => TypedEpic((
        Stream<ShowToastAction> stream,
        EpicStore<AppState> store,
      ) =>
          stream.asyncExpand((action) async* {
            await Fluttertoast.showToast(msg: action.text);
          }));

  static Epic<AppState> _showLocalNotification() => TypedEpic((
        Stream<ShowLocalNotification> stream,
        EpicStore<AppState> store,
      ) =>
          stream.asyncExpand((action) async* {
            try {
              await FlutterLocalNotificationsPlugin().initialize(
                InitializationSettings(
                  android: AndroidInitializationSettings('ic_launcher'),
           //     iOS: IOSInitializationSettings(),
                ),
              );

              await FlutterLocalNotificationsPlugin().show(
                1,
                action.title,
                action.text,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    'flutter_twilio_conversations',
                    'Local Notifications',
                    channelDescription: 'Notifies about channel updates',
                    importance: Importance.max,
                    priority: Priority.high,
                    onlyAlertOnce: true,
                    showWhen: false,
                    styleInformation: BigTextStyleInformation(''),
                  ),
                  // iOS: IOSNotificationDetails(
                  //   threadIdentifier: 'flutter_twilio_conversations',
                  // ),
                ),
              );
            } catch (e) {
              print('Failed to present local notification: $e');
            }
          }));
}
