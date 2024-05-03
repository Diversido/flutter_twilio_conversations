import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class TwilioConversationsPlugin extends FlutterTwilioConversationsPlatform {
  TwilioConversationsPlugin();

  /// Registers this class as the default instance of [FlutterTwilioConversationsPlatform].
  static void registerWith(Registrar registrar) {
    FlutterTwilioConversationsPlatform.instance = TwilioConversationsPlugin();
  }

  @override
  Future<void> create() async {
    print("here on web");
  }
}
