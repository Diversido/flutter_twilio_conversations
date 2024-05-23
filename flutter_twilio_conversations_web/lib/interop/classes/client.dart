import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/event_emitter.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/user.dart';
import 'package:js/js.dart';

import 'channel.dart';

// Define Twilio.Conversations.Client class
@JS('Twilio.Conversations.Client')
class TwilioConversationsClient extends EventEmitter {
  external factory TwilioConversationsClient(String token);

  external ConnectionState connectionState;
  external String get version;
  external bool reachabilityEnabled;
  external TwilioConversationsUser get user;

  // external createConversation();
  // external getConversationBySid();
  // external getConversationByUniqueName();
  external JSPaginator<TwilioConversationsChannel> getSubscribedConversations();
  external List<TwilioConversationsUser> getSubscribedUsers();
  external dynamic getUser();
  // external handlePushNotification();
  // external removePushRegistrations();
  // external setPushRegistrationId();
  // external shutdown();
  // external unsetPushRegistrationId();
  // external updateToken();
  // external parsePushNotification();

  // external set connectionState(ConnectionState state);

  // external set user(TwilioConversationsUser state);

  // external factory TwilioConversationsClient(String token);

  // external dynamic getChannelBySid(String sid);

  // external dynamic getChannelByUniqueName(String uniqueName);

  // external dynamic createConversation();

  // external dynamic reachabilityEnabled();

  // external dynamic connectionError();

  // external TwilioConversationsClient connectionStateChange();
}

// TODO remove
extension Interop on TwilioConversationsClient {
  ClientModel toModel() {
    return ClientModel(
      connectionState: connectionState,
      myIdentity: user.toModel().identity,
      channels: null,
      users: null,
      isReachabilityEnabled: true,
    );
  }
}
