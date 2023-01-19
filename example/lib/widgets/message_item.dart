import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store, message),
      builder: (context, viewModel) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: viewModel.isMyMessage()
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 6,
              ),
              child: Text('${message.author} @ ${message.dateCreated}'),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: viewModel.isMyMessage() ? Colors.blue : Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: message.hasMedia
                    ? FutureBuilder(
                        future: message.media?.getDownloadURL(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data as String,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            );
                          }

                          return CircularProgressIndicator();
                        },
                      )
                    : Text(
                        message.messageBody,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final ConversationDialog? dialog;
  final String? myIdentity;
  final Message message;

  _ViewModel(
    Store<AppState> _store,
    this.message,
  )   : dialog = _store.state.selectedDialog,
        myIdentity = _store.state.chatClient?.myIdentity;

  bool isMyMessage() => (message.author ?? '') == myIdentity;

  @override
  List<Object?> get props => [
        dialog,
      ];
}
