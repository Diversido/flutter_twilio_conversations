import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/init_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';

class AuthWidget extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store),
      onInitialBuild: (viewModel) {
        // enter test token here to use it without typing
        _textEditingController.text = '';
      },
      builder: (context, viewModel) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Twilio Conversations Flutter',
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _textEditingController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Twilio chatJWT Token',
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => _textEditingController.text.trim().isNotEmpty
                  ? viewModel.initialize(
                      _textEditingController.text.trim(),
                    )
                  : viewModel.showEmptyFieldsToast(),
              child: Text('Initialize'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final Store<AppState> _store;

  _ViewModel(this._store);

  void initialize(String token) => _store.dispatch(InitializeAction(token));

  void showEmptyFieldsToast() => _store.dispatch(
        ShowToastAction('Enter token into the field above'),
      );

  @override
  List<Object?> get props => [];
}
