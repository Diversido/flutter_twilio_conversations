@JS()

import 'package:flutter_twilio_conversations_web/interop/classes/client.dart';
import 'package:js/js.dart';

// Define Twilio.Conversations.Channel class
@JS('Twilio.Conversations.Channel')
class TwilioConversationsChannel {
  external TwilioConversationsChannel();

  external dynamic sendMessage(String message);

  external dynamic remove();

  external dynamic on(String event, Function handler);
}

Future<dynamic?> createConversation(String token, dynamic properties) async {

  try {
    var client = TwilioConversationsClient(token);
    //var channels = await promiseToFuture<dynamic>(client.createConversation());
   // print(client.reachabilityEnabled());

    //  await promiseToFuture<dynamic>(createConversation(token, properties));
    return client;
  } catch (e) {
    print(e);
  }
}
