import 'package:flutter_twilio_conversations_web/interop/classes/client.dart';
import 'package:js/js_util.dart';

class NotificationsMethods {
  Future<void> registerForNotification(
    TwilioConversationsClient? chatClient, {
    required String channel,
    required String token,
  }) async {
    await promiseToFuture<void>(
      chatClient?.setPushRegistrationId(channel, token),
    );
  }

  Future<void> unregisterForNotification(
    TwilioConversationsClient? chatClient, {
    required String channel,
    required String token,
  }) async {
    await promiseToFuture<void>(
      chatClient?.removePushRegistrations(channel, token),
    );
  }
}
