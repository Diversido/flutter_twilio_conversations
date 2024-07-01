import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/messages_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/actions/ui_actions.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations_example/widgets/conversation_dialog.dart';

class SendBar extends StatefulWidget {
  const SendBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SendBarState();
}

class _SendBarState extends State<SendBar> {
  late TextEditingController messageTextController;

  @override
  void initState() {
    super.initState();
    messageTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store),
      builder: (context, viewModel) => Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 56,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: const Icon(
                        Icons.image_sharp,
                        size: 24,
                      ),
                      onTap: () async {
                        if (await viewModel.hasGalleryAccess()) {
                          try {
                            final pickedImage = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 60,
                              maxHeight: 1000,
                              maxWidth: 1000,
                            );

                            if (pickedImage != null) {
                              dynamic image;
                              if (kIsWeb) {
                                image = Image.network(pickedImage.path);
                              } else {
                                image = Image.file(File(pickedImage.path));
                              }
                              // send picked file
                              viewModel.sendImage(image);
                            }
                          } catch (e) {
                            debugPrint('Image picker error: $e');
                          }
                        } else {
                          // no access to photos
                          viewModel.showNoPhotoAccessToast();
                        }
                      },
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 140,
                      child: TextField(
                        maxLength: 300,
                        controller: messageTextController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: 'Type message…',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.send_rounded,
                        size: 24,
                      ),
                      onTap: () {
                        if (messageTextController.text.trim().isNotEmpty &&
                            viewModel.dialog!.channel.hasSynchronized) {
                          viewModel.sendTextMessage(
                              messageTextController.text.trim());
                          messageTextController.clear();
                        } else if (messageTextController.text
                                .trim()
                                .isNotEmpty &&
                            !viewModel.dialog!.channel.hasSynchronized) {
                          debugPrint(
                              'TwilioLog --- Conversation is not synced, trying to send the message carefully');
                          viewModel.sendTextMessage(
                            messageTextController.text.trim(),
                          );
                          messageTextController.clear();
                        }
                      },
                    ),
                  ],
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
  final Store<AppState> _store;
  final ConversationDialog? dialog;

  _ViewModel(this._store) : dialog = _store.state.selectedDialog;

  Future<bool> hasGalleryAccess() async {
    if (kIsWeb) {
      debugPrint('Permission: Web');
      return true;
    } else if (Platform.isIOS) {
      final permission = await Permission.photos.request();
      debugPrint('Permission: $permission');
      return permission.isGranted;
    } else if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      final response =
          sdkInt > 28 ? await Permission.photos.request().isGranted : true;
      return response;
    }
    return false;
  }

  void sendImage(File image) =>
      _store.dispatch(SendImageAction(dialog!.channel, image));

  void sendTextMessage(String text) {
    _store.dispatch(
      SendTextMessageAction(dialog!.channel, text),
    );
  }

  void showNoPhotoAccessToast() => _store.dispatch(
        ShowToastAction('No Access to Photos'),
      );

  @override
  List<Object?> get props => [
        dialog,
      ];
}
