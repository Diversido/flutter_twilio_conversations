import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:js/js.dart';

// Define Twilio.Conversations.Client class
@JS('Twilio.Conversations.Client')
class TwilioConversationsClient extends EventEmitter {
  external ConnectionState get connectionState;
  external String get version;

  external set connectionState(ConnectionState state);

  external factory TwilioConversationsClient(String token);

  external dynamic getChannelBySid(String sid);

  external dynamic getChannelByUniqueName(String uniqueName);

  external dynamic createConversation();

  external dynamic reachabilityEnabled();

  external dynamic connectionError();

  external TwilioConversationsClient connectionStateChange();
}

extension Interop on TwilioConversationsClient {
  ClientModel toModel() {
    return ClientModel(
      connectionState: connectionState,
      version: version,
    );
  }
}
