import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/app.dart';
import 'package:flutter_twilio_conversations_example/redux/effects/subscriptions_middleware.dart';
import 'package:flutter_twilio_conversations_example/redux/effects/twilio_middleware.dart';
import 'package:flutter_twilio_conversations_example/redux/effects/ui_middleware.dart';
import 'package:flutter_twilio_conversations_example/redux/reducers/app_reducer.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ],
  );
  final store = Store<AppState>(
    AppReducer(),
    initialState: AppState.initial(),
    middleware: [
      UiMiddleware(),
      TwilioMiddleware(),
      MessengerSubscriptionsMiddleware(),
    ],
  );

  runApp(
    App(
      store: store,
    ),
  );
}
