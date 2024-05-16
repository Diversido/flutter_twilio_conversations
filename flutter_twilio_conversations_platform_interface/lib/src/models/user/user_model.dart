import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

class UserModel {
  //#region Private API properties
  final String? friendlyName;

  final Attributes? attributes;

  final String? identity;

  UserModel(
      {required this.friendlyName,
      required this.attributes,
      required this.identity});
}
