import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/pages/home_page.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';

class App extends StatefulWidget {
  final Store<AppState> store;

  const App({Key? key, required this.store}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<App> {
  @override
  Widget build(BuildContext context) => StoreProvider(
        store: widget.store,
        child: MaterialApp(
          title: 'Twilio Conversations',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              color: Colors.blue,
              toolbarTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          home: HomePage(),
        ),
      );
}
