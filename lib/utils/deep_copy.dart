abstract class DeepCopyable {
  T deepCopy<T>();
}

List<T> listDeepCopy<T>(List list) {
  List<T> newList = <T>[];
  for (var value in list) {
    newList.add(value is Map<String, dynamic>
        ? mapDeepCopy(value)
        : value is List
            ? listDeepCopy(value)
            : value is Set
                ? setDeepCopy(value)
                : value is DeepCopyable
                    ? value.deepCopy()
                    : value);
  }

  return newList;
}

Set<T> setDeepCopy<T>(Set s) {
  Set<T> newSet = <T>{};
  for (var value in s) {
    newSet.add(value is Map<String, dynamic>
        ? mapDeepCopy(value)
        : value is List
            ? listDeepCopy(value)
            : value is Set
                ? setDeepCopy(value)
                : value is DeepCopyable
                    ? value.deepCopy()
                    : value);
  }

  return newSet;
}

Map<K, V> mapDeepCopy<K, V>(Map<K, V> map) {
  Map<K, V> newMap = <K, V>{};
  map.forEach((key, value) {
    newMap[key] = (value is Map<String, dynamic>
        ? mapDeepCopy(value)
        : value is List
            ? listDeepCopy(value)
            : value is Set
                ? setDeepCopy(value)
                : value is DeepCopyable
                    ? value.deepCopy()
                    : value) as V;
  });

  return newMap;
}