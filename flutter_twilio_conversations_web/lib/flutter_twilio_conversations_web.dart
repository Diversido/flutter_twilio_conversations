import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import '../method_channel/method_channel_flutter_twilio_conversations.dart';

class TwilioConversationsPlugin extends FlutterTwilioConversationsPlatform {
  TwilioConversationsPlugin();

  /// Registers this class as the default instance of [FlutterTwilioConversationsPlatform].
  static void registerWith(Registrar registrar) {
    FlutterTwilioConversationsPlatform.instance = TwilioConversationsPlugin();
  }

  @override
  Future<ChatClient?> create(String token, Properties properties) {
    print("here on web");
  }
}
