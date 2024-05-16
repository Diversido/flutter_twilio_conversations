import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

class ChannelModel {
  final String? sid;
  final Attributes? attributes;
  final DateTime? dateCreated;
  final String? createdBy;

  const ChannelModel({
    required this.sid,
    required this.attributes,
    required this.dateCreated,
    required this.createdBy,
  });

  @override
  String toString() {
    return '{ sid: $sid, attributes: $attributes, dateCreated: $dateCreated, createdBy: $createdBy}';
  }
}
