@JS()

import 'package:flutter_twilio_conversations_web/interop/classes/client.dart';
import 'package:flutter_twilio_conversations_web/methods/mapper.dart';
import 'package:js/js.dart';


Future<dynamic> createTwilioConversationsClient(
    String token, dynamic properties) async {
  try {
    return await TwilioConversationsClient(token);  
  } catch (e) {
    print(e);
  }
}


getTwilioConversationBySidOrUniqueName(String channelSidOrUniqueName){

}
