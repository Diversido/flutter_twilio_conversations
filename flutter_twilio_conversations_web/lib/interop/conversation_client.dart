@JS()
library interop;

import 'package:collection/collection.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:twilio_programmable_video_web/src/interop/classes/js_map.dart';
import 'package:twilio_programmable_video_web/src/interop/classes/local_audio_track.dart';
import 'package:twilio_programmable_video_web/src/interop/classes/local_audio_track_publication.dart';
import 'package:twilio_programmable_video_web/src/interop/classes/local_data_track.dart';
import 'package:twilio_programmable_video_web/src/interop/classes/local_video_track_publication.dart';
import 'package:twilio_programmable_video_web/src/interop/classes/room.dart';
import 'package:twilio_programmable_video_web/twilio_programmable_video_web.dart';
import 'package:twilio_programmable_video_platform_interface/twilio_programmable_video_platform_interface.dart';



@JS('Twilio.Conversations.create')
 external Future<ChatClient?> create(
    print("here on web")
 );
