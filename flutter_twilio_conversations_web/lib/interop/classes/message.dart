// Define Twilio.Conversations.Client class
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:js/js.dart';
import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';

@JS('Twilio.Conversations.Message')
class TwilioConversationsMessage {
  external dynamic get updated;
  external TwilioConversationsChannel conversation;
  external String sid;
  external String author;
  external DateTime dateCreated;
  external String body;
  external String channelSid;
  external String participantSid; //TODO needs to be done

  external int index;
  // external List<Media> attachedMedia;
  external Map<dynamic, dynamic> attributes;
}

extension Interop on TwilioConversationsMessage {
  Message toModel() {
    return Message(sid, author, dateCreated, channelSid, participantSid, null,
        body, null, index, false, null, null);
  }
}
