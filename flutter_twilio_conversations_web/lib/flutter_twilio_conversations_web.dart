import 'dart:async';

import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/conversation_client.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart'
    as TwilioChatClient;
import 'package:flutter_twilio_conversations_web/listeners/client_conversations_event_listener.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class TwilioConversationsPlugin extends FlutterTwilioConversationsPlatform {
  static TwilioChatClient.TwilioConversationsClient? _chatClient;
  static ChatClientEventListener? _chatClientListener;

  static final _chatClientStreamController =
      StreamController<BaseChatClientEvent>.broadcast();

  /// Registers this class as the default instance of [FlutterTwilioConversationsPlatform].
  static void registerWith(Registrar registrar) {
    FlutterTwilioConversationsPlatform.instance = TwilioConversationsPlugin();
  }

  void _onConnected() async {
    final chatClient = _chatClient;
    if (chatClient != null) {
      _chatClientListener =
          ChatClientEventListener(chatClient, _chatClientStreamController);
      _chatClientListener!.addListeners();

      final _clientModel = ConnectionStateChange(_chatClient!.toModel());
      _chatClientStreamController.add(_clientModel);
      //  debug('Connected to room: ${room.name}');
      _chatClientStreamController.onListen = null;
    }
  }

  @override
  Future<ChatClient?> create(String token, Properties properties) async {
    _chatClientStreamController.onListen = _onConnected;
    try {
      _chatClient = await createConversation(token, {"logLevel": "Debug"});
      print(_chatClient!.version);
      var clientModel = _chatClient!.toModel();
      return ChatClient(clientModel.toString());
    } catch (e) {
      print('error: createConversation ${e}');
    }
  }

  @override
  Stream<BaseChatClientEvent> chatClientStream() {
    print('TwilioConversationsPlugin.create => starting stream');
    return _chatClientStreamController.stream;
  }
}
