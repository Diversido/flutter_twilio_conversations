import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

void main() {
  setUpAll(() {});

  group('.fromMap()', () {
    test('should return null when map is null', () {
      final member = Member.fromMap(null);
      expect(member, isNull);
    });

    test('should create a valid Member from a complete map', () {
      final input = {
        'sid': 'SM123',
        'type': 'chat',
        'channelSid': 'CH123',
        'attributes': {'key': 'value'},
        'lastReadMessageIndex': 5,
        'lastConsumptionTimestamp': '2023-10-05T12:00:00Z',
        'identity': 'user1',
      };

      final member = Member.fromMap(input);
      expect(member, isNotNull);
      expect(member!.sid, equals('SM123'));
      expect(member.type.toString().toLowerCase(), contains('chat'));
      expect(member.attributes, isNotNull);
      expect(member.lastReadMessageIndex, equals(5));
      expect(member.lastConsumptionTimestamp, equals('2023-10-05T12:00:00Z'));
      expect(member.identity, equals('user1'));
    });

    test('should create a valid Member from with no attributes', () {
      final input = {
        'sid': 'SM123',
        'type': 'chat',
        'channelSid': 'CH123',
        'lastReadMessageIndex': 5,
        'lastConsumptionTimestamp': '2023-10-05T12:00:00Z',
        'identity': 'user1',
      };

      final member = Member.fromMap(input);
      expect(member, isNotNull);
      expect(member!.sid, equals('SM123'));
      expect(member.type.toString().toLowerCase(), contains('chat'));
      expect(member.attributes!.type, AttributesType.NULL);
      expect(member.attributes!.getJSONArray(), null);
      expect(member.lastReadMessageIndex, equals(5));
      expect(member.lastConsumptionTimestamp, equals('2023-10-05T12:00:00Z'));
      expect(member.identity, equals('user1'));
    });
  });
}
