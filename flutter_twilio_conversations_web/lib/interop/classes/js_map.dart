@JS()
library js_map;

import 'dart:js_util';
import 'package:js/js.dart';

Map jsToMap(jsObject) {
  try {
    return new Map.fromIterable(_getKeysOfObject(jsObject), value: (key) {
      var property = getProperty(jsObject, key);

      if (property is List) {
        return property.map((element) {
          if (element is JSMap) {
            return jsToMap(element);
          }
          return element;
        }).toList();
      } else if (property is JSMap) {
        return jsToMap(property);
      }

      return property;
    });
  } catch (e) {
    return {};
  }
}

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

@JS('Map')
class JSMap<K, V> {
  /// Returns an [JSIterator] of all the key value pairs in the [Map]
  ///
  /// The [JSIterator] returns the key value pairs as a [List<dynamic>].
  /// The [List] always contains two elements. The first is the key and the second is the value.
  @JS('prototype.entries')
  external JSIterator<List<dynamic>> entries();

  @JS('prototype.keys')
  external JSIterator<K> keys();

  @JS('prototype.values')
  external JSIterator<V> values();

  external int get size;

  external factory JSMap();
}

extension Interop<K, V> on JSMap<K, V> {
  Map<K, V> toDartMap() {
    final returnMap = <K, V>{};

    final jsKeys = keys();
    final jsValues = values();

    var nextKey = jsKeys.next();
    var nextValue = jsValues.next();

    while (!nextKey.done) {
      returnMap[nextKey.value] = nextValue.value;
      nextKey = jsKeys.next();
      nextValue = jsValues.next();
    }

    return returnMap;
  }
}

@JS('Paginator')
class JSPaginator<T> {
  external List<T> items;

  external factory JSPaginator();
}

@JS()
class JSIterator<T> {
  external IteratorValue<T> next();

  external factory JSIterator();
}

@JS()
class IteratorValue<T> {
  external T get value;
  external bool get done;

  external factory IteratorValue();
}

List<T> iteratorToList<T, V>(
  JSIterator<V> iterator,
  T Function(V value) mapper,
) {
  final list = <T>[];
  var result = iterator.next();
  while (!result.done) {
    list.add(
      mapper(result.value),
    );

    result = iterator.next();
  }
  return list;
}

void iteratorForEach<V>(
  JSIterator<V> iterator,
  bool Function(V value) mapper,
) {
  var result = iterator.next();
  while (!result.done) {
    final earlyBreak = mapper(result.value);
    if (earlyBreak) break;
    result = iterator.next();
  }
}
