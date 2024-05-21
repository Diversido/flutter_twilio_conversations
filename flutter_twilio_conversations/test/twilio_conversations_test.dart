import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twilio_conversations/src/parts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final methodCalls = <MethodCall>[];
  var nativeDebugIsCalled = false;
  var nativeConnectIsCalled = false; // ignore: unused_local_variable

  setUpAll(() {
    // ignore: missing_return
    MethodChannel('flutter_twilio_conversations')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      methodCalls.add(methodCall);
      switch (methodCall.method) {
        case 'debug':
          nativeDebugIsCalled = true;
          break;
      }
    });
  });

  tearDown(() async {
    methodCalls.clear();
  });

  group('.debug()', () {
    test('should enable debug in dart', () async {
      //await TwilioConversationsClient.debug(dart: true);

      expect(nativeDebugIsCalled, true);
      expect(methodCalls, <Matcher>[
        isMethodCall(
          'debug',
          arguments: <String, bool>{'native': false, 'sdk': false},
        )
      ]);
    });

    test('should disable debug in dart', () async {
      //await TwilioConversationsClient.debug(dart: false);

      expect(nativeDebugIsCalled, true);
      expect(methodCalls, <Matcher>[
        isMethodCall(
          'debug',
          arguments: <String, bool>{'native': false, 'sdk': false},
        )
      ]);
    });
  });
}
