import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/user.dart';
import 'package:flutter_twilio_conversations_web/types/connection_state.dart';
import 'package:js/js.dart';
import 'channel.dart';

@JS('Twilio.Conversations.Client')
class TwilioConversationsClient extends EventEmitter {
  external factory TwilioConversationsClient(String token);

  external ConnectionState connectionState;
  external String get version;
  external bool reachabilityEnabled;
  external TwilioConversationsUser get user;

  external JSPaginator<TwilioConversationsChannel> getSubscribedConversations();
  external dynamic getSubscribedUsers();

  external dynamic getConversationBySid(String channelSid);
  external dynamic updateToken(String token);
  external dynamic shutdown();
  external dynamic getConversationByUniqueName(String UniqueName);
  external dynamic getUser(String identity);
}
