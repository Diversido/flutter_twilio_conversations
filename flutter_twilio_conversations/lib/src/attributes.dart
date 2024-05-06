part of flutter_twilio_conversations;

class Attributes {
  //#region Private API properties
  final AttributesType _type;

  final String _json;
  //#endregion

  /// Returns attributes type
  AttributesType get type => _type;

  Attributes(this._type, this._json);

  factory Attributes.fromMap(Map<String, dynamic> map) {
    final type =
        EnumToString.fromString(AttributesType.values, map['type'] ?? 'null') ??
            AttributesType.NULL;
    return Attributes(type, map['data'] ?? '');
  }

  Map<String, dynamic>? getJSONObject() {
    if (type != AttributesType.OBJECT) {
      return null;
    } else {
      return jsonDecode(_json);
    }
  }

  List<Map<String, dynamic>>? getJSONArray() {
    if (type != AttributesType.ARRAY) {
      return null;
    } else {
      return List<Map<String, dynamic>>.from(jsonDecode(_json));
    }
  }

  String? getString() {
    if (type != AttributesType.STRING) {
      return null;
    } else {
      return _json;
    }
  }

  num? getNumber() {
    if (type != AttributesType.NUMBER) {
      return null;
    } else {
      return num.tryParse(_json);
    }
  }

  bool? getBoolean() {
    if (type != AttributesType.BOOLEAN) {
      return null;
    } else {
      return _json == 'true';
    }
  }
}

enum AttributesType {
  OBJECT,
  ARRAY,
  STRING,
  NUMBER,
  BOOLEAN,
  NULL,
}
