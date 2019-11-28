String firstCharToLowerCase(String string) {
  if (string.isEmpty) {
    return string;
  }
  return string.replaceRange(0, 1, string[0].toLowerCase());
}

Map<String, dynamic> keysToLowerCase(Map<String, dynamic> map) {
  map.forEach((key, value) {
    if (value is Map) {
      map[firstCharToLowerCase(key)] = keysToLowerCase(value);
    } else {
      map[firstCharToLowerCase(key)] = value;
    }
    map.remove(key);
  });
  return map;
}

Map<String, dynamic> keysToUpperCase(Map<String, dynamic> map) {
  map.forEach((key, value) {
    if (value is Map) {
      map[firstCharToUpperCase(key)] = keysToUpperCase(value);
    } else {
      map[firstCharToUpperCase(key)] = value;
    }
    map.remove(key);
  });
  return map;
}

String firstCharToUpperCase(String string) {
  if (string.isEmpty) {
    return string;
  }
  return string.replaceRange(0, 1, string[0].toUpperCase());
}
