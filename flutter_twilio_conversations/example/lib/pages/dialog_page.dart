// ignore_for_file: prefer_const_constructors

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';
import 'package:flutter_twilio_conversations_example/widgets/message_item.dart';
import 'package:flutter_twilio_conversations_example/widgets/send_bar.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({Key? key}) : super(key: key);

  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store),
      builder: (context, viewModel) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            viewModel.dialog?.typingMessage() ?? 'Dialog',
          ),
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () => viewModel.closeDialog(),
          ),
          automaticallyImplyLeading: false,
        ),
        body: viewModel.messages.isEmpty
            ? viewModel.dialog != null
                ? Center(
                    child: Text('Empty dialog'),
                  )
                : Container()
            : GestureDetector(
                child: ListView.separated(
                  itemBuilder: (context, index) => MessageItem(
                    viewModel.messages[index],
                    key: ValueKey(
                      viewModel.messages[index].sid,
                    ),
                  ),
                  separatorBuilder: (context, index) => Container(
                    height: 26,
                  ),
                  itemCount: viewModel.messages.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 10,
                  ),
                  reverse: true,
                  shrinkWrap: true,
                ),
                onTap: () => FocusScope.of(context).unfocus(),
              ),
        bottomNavigationBar: const SendBar(),
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final Store<AppState> _store;
  final ConversationDialog? dialog;
  final List<Message> messages;

  _ViewModel(this._store)
      : dialog = _store.state.selectedDialog,
        messages =
            _store.state.selectedDialog?.messages.reversed.toList() ?? [];

  void markDialogRead() {
    if (dialog != null) {
      // TODO mark dialog read when opening?
    }
  }

  void closeDialog() => _store.dispatch(CloseConversationAction());

  @override
  List<Object?> get props => [
        dialog,
        messages,
      ];
}
