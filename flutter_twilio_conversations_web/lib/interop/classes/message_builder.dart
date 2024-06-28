import 'package:dio/dio.dart';
import 'package:flutter_twilio_conversations_web/interop/classes/js_map.dart';
import 'package:js/js.dart';

@JS('Twilio.Conversations.MessageBuilder')
class MessageBuilder {
  external factory MessageBuilder();

  external MessageBuilder setBody(String body);
  external MessageBuilder setAttributes(JSMap attributes);
  external MessageBuilder addMedia(FormData media);
  external MessageBuilder withOptions(JSMap options);
  external dynamic build();
}
