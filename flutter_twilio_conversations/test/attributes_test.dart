import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

void main() {
  setUpAll(() {});

  group('.fromMap()', () {
    const objectExample = {
      'type': 'object',
      'data': '{"key": "value"}',
    };

    const arrayExample = {
      'type': 'array',
      'data': '[{"key": "value"}, {"key1": "value1"}]',
    };

    const stringExample = {
      'type': 'string',
      'data': 'string',
    };

    const numberExample = {
      'type': 'number',
      'data': '123',
    };

    const booleanExample = {
      'type': 'boolean',
      'data': 'true',
    };

    const nullExample = {
      'type': 'null',
      'data': 'null',
    };

    const invalidExample = {
      'invalid': 'invalid',
    };

    const invalidObjectExample = {
      'type': 'object',
      'data': 'not a json',
    };

    test('should construct from OBJECT', () async {
      final object = Attributes.fromMap(objectExample);
      expect(object.type, AttributesType.OBJECT);
      expect(object.getBoolean(), isNull);
      expect(object.getNumber(), isNull);
      expect(object.getString(), isNull);
      expect(object.getJSONArray(), isNull);
      expect(object.getJSONObject(), isNotNull);
      expect(object.getJSONObject(), {"key": "value"});
    });

    test('should construct from ARRAY', () async {
      final array = Attributes.fromMap(arrayExample);
      expect(array.type, AttributesType.ARRAY);
      expect(array.getJSONObject(), isNull);
      expect(array.getBoolean(), isNull);
      expect(array.getNumber(), isNull);
      expect(array.getString(), isNull);
      expect(array.getJSONArray(), isNotNull);
      expect(array.getJSONArray(), [
        {"key": "value"},
        {"key1": "value1"}
      ]);
    });

    test('should construct from STRING', () async {
      final string = Attributes.fromMap(stringExample);
      expect(string.type, AttributesType.STRING);
      expect(string.getBoolean(), isNull);
      expect(string.getNumber(), isNull);
      expect(string.getJSONArray(), isNull);
      expect(string.getJSONObject(), isNull);
      expect(string.getString(), isNotNull);
      expect(string.getString(), "string");
    });

    test('should construct from NUMBER', () async {
      final number = Attributes.fromMap(numberExample);
      expect(number.type, AttributesType.NUMBER);
      expect(number.getBoolean(), isNull);
      expect(number.getString(), isNull);
      expect(number.getJSONArray(), isNull);
      expect(number.getJSONObject(), isNull);
      expect(number.getNumber(), isNotNull);
      expect(number.getNumber(), 123);
    });

    test('should construct from BOOLEAN', () async {
      final boolean = Attributes.fromMap(booleanExample);
      expect(boolean.type, AttributesType.BOOLEAN);
      expect(boolean.getNumber(), isNull);
      expect(boolean.getString(), isNull);
      expect(boolean.getJSONArray(), isNull);
      expect(boolean.getJSONObject(), isNull);
      expect(boolean.getBoolean(), isNotNull);
      expect(boolean.getBoolean(), true);
    });

    test('should construct from NULL', () async {
      final nullAttr = Attributes.fromMap(nullExample);
      expect(nullAttr.type, AttributesType.NULL);
      expect(nullAttr.getBoolean(), isNull);
      expect(nullAttr.getNumber(), isNull);
      expect(nullAttr.getString(), isNull);
      expect(nullAttr.getJSONArray(), isNull);
      expect(nullAttr.getJSONObject(), isNull);
    });

    test('should construct from invalid', () async {
      final invalidAttr = Attributes.fromMap(invalidExample);
      expect(invalidAttr.type, AttributesType.NULL);
      expect(invalidAttr.getBoolean(), isNull);
      expect(invalidAttr.getNumber(), isNull);
      expect(invalidAttr.getString(), isNull);
      expect(invalidAttr.getJSONArray(), isNull);
      expect(invalidAttr.getJSONObject(), isNull);

      final invalidObject = Attributes.fromMap(invalidObjectExample);
      expect(invalidObject.type, AttributesType.OBJECT);
      expect(invalidObject.getBoolean(), isNull);
      expect(invalidObject.getNumber(), isNull);
      expect(invalidObject.getString(), isNull);
      expect(invalidObject.getJSONArray(), isNull);
      expect(invalidObject.getJSONObject, throwsException);
    });
  });
}
