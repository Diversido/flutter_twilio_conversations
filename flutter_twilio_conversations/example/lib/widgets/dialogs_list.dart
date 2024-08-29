// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class DialogsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store),
      builder: (context, viewModel) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Dialogs',
          ),
        ),
        body: viewModel.dialogs.isNotEmpty
            ? ListView.builder(
                itemCount: viewModel.dialogs.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () =>
                      viewModel.openConversation(viewModel.dialogs[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                viewModel.dialogs[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                viewModel.dialogs[index].unreadCount > 0
                                    ? ' (${viewModel.dialogs[index].unreadCount})'
                                    : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            viewModel.dialogs[index].lastMessageText ??
                                'No messages loaded',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final Store<AppState> _store;
  final ChatClient? chatClient;
  final List<ConversationDialog> dialogs;

  final bool isTwilioInitializing;
  final bool isClientSyncing;

  _ViewModel(this._store)
      : chatClient = _store.state.chatClient,
        dialogs = _store.state.dialogs,
        isTwilioInitializing = _store.state.isTwilioInitializing,
        isClientSyncing = _store.state.isClientSyncing;

  void openConversation(ConversationDialog dialog) =>
      _store.dispatch(OpenConversationAction(dialog));

  @override
  List<Object?> get props => [
        dialogs,
        isTwilioInitializing,
        isClientSyncing,
      ];
}
