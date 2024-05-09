@JS()
library twilioconversationsjs;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/client.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

// Define Twilio.Conversations.Client class
@JS('Twilio.Conversations.Client')
class TwilioConversationsClient {
  external dynamic get connectionState;

  external factory TwilioConversationsClient(String token);

  external dynamic getChannelBySid(String sid);

  external dynamic getChannelByUniqueName(String uniqueName);

  external dynamic createConversation();

  external dynamic reachabilityEnabled();

  external dynamic getChannelDescriptors();

  external dynamic createChannel(String type, dynamic options);

  external dynamic getUserChannels(String identity);

  external dynamic getUserChannelDescriptors(String identity);

  external dynamic getSubscribedChannels();

  external dynamic subscribeToChannel(String channel);

  external dynamic unsubscribeFromChannel(String channel);

  external dynamic updateToken(String token);
}

// Define Twilio.Conversations.Channel class
@JS('Twilio.Conversations.Channel')
class TwilioConversationsChannel {
  external TwilioConversationsChannel();

  external dynamic sendMessage(String message);

  external dynamic remove();

  external dynamic on(String event, Function handler);
}

Future<dynamic?> createConversation(String token, dynamic properties) async {
  print(properties);
  try {
    var client = TwilioConversationsClient(token);
    //var channels = await promiseToFuture<dynamic>(client.createConversation());
    print(client.reachabilityEnabled());

    //  await promiseToFuture<dynamic>(createConversation(token, properties));
  } catch (e) {
    print(e);
  }
}
