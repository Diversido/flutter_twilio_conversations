import 'package:flutter_twilio_conversations_web/interop/classes/channel.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/member.dart';
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
  external String participantSid;
  external String attachedMedia;

  external int index;
  //TODO external List<Media> attachedMedia;
  external JSMap attributes;

  external TwilioConversationsMember getParticipant();
}
