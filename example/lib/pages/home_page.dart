import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/pages/router_delegate.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store),
      builder: (context, viewModel) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Router(
            routerDelegate: AppRouterDelegate(
              StoreProvider.of<AppState>(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final String? twilioToken;
  final ChatClient? chatClient;
  final List<ConversationDialog> dialogs;

  final bool showAuthScreen;

  _ViewModel(Store<AppState> _store)
      : twilioToken = _store.state.twilioToken,
        chatClient = _store.state.chatClient,
        dialogs = _store.state.dialogs,
        showAuthScreen = _store.state.chatClient == null &&
            !_store.state.isTwilioInitializing;

  @override
  List<Object?> get props => [
        dialogs,
      ];
}
