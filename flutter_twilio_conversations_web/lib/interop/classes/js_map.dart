@JS()
library js_map;

import 'dart:js';
import 'dart:js_util';
import 'package:js/js.dart';

Map jsToMap(jsObject) {
  try {
    return new Map.fromIterable(_getKeysOfObject(jsObject), value: (key) {
      var property = getProperty(jsObject, key);
      if (property is! String &&
          property is! num &&
          property is! bool &&
          property is! List &&
          property is! Map) {
        return jsToMap(property);
      } else {
        return property;
      }
    });
  } catch (e) {
    print(e);
    return {};
  }
}

// https://www.phind.com/search?cache=q0tfe6yb900vsbhbykhl2ejx
//   static Object jsToDart(jsObject) {
//   if (jsObject is JsArray || jsObject is Iterable) {
//     return jsObject.map(jsToDart).toList();
//   }
//   if (jsObject is JsObject) {
//     return Map.fromIterable(
//       getObjectKeys(jsObject),
//       value: (key) => jsToDart(jsObject[key]),
//     );
//   }
//   return jsObject;
// }

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
