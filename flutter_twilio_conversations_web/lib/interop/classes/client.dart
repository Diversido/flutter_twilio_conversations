import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/user.dart';
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
  external List<TwilioConversationsUser> getSubscribedUsers();
  external dynamic getConversationBySid(String channelSid);
  external dynamic updateToken(String token);
  external dynamic getConversationByUniqueName(String UniqueName);

}
