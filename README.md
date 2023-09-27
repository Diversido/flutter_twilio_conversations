By [**Diversido**](https://www.diversido.io)

## flutter_twilio_conversations
This package is based on [Twilio Programmable Chat Plugin](https://pub.dev/packages/twilio_programmable_chat). We decided to make our own version of it and rebase to Twilio Conversations SDK since Twilio Programmeble Chat is sunsetting this year. It is not an official plugin and still requires some fixes and further maintenance, please do not report issues of it to Twilio — if you have any issues, please file an issue instead of contacting support.

## Installing the plugin

📂 **`pubspec.yaml`**:

```yaml
dependencies:
  flutter_twilio_conversations: '^1.1.2'
```

## Setup
No special setup required, most of the tips on Console setup can be found in [Twilio's Native SDK Guides](https://www.twilio.com/docs/conversations)

## Supported platforms
* Android
* iOS

## Platform Specifics

The iOS and Android SDKs take different approaches to push notifications. **Notable differences include:**

## iOS
1. The iOS SDK uses APNs whereas Android uses FCM.
2. The iOS SDK handles receiving and displaying push notifications.
3. Due to the fact that APNs token format has changed across iOS implementations, we have elected to retrieve the token from the OS ourselves at time of registration rather than attempting to anticipate what method of encoding might be used when transferring the token back and forth across layers of the app, or what format the token might take.

## Android
1. The Android SDK offers options for GCM and FCM. As GCM has largely been deprecated by Google, we have elected to only handle FCM.
2. The Android SDK does not receive messages or handle notifications.
3. Rather than introducing a dependency on `firebase` to the plugin, we have elected to leave token retrieval, message and notification handling to the user of the plugin.
    - An example of this can be seen in the example app.
    - Notable parts of the implementation in the example app include:
      * `main.dart` - which configures `FirebaseMessaging` with message handlers,
       initializes `FlutterLocalNotificationsPlugin`, and creates a notification channel.

# Development and Contributing
Feel free to contribute by creating merge requests!