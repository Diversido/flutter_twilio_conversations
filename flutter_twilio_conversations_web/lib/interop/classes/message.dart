import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/twilio_json.dart';
import 'package:js/js.dart';

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
  external JSONValue attributes;
}