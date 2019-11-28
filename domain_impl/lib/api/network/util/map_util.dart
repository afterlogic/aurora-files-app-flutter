String firstCharToLowerCase(String string) {
  if (string.isEmpty) {
    return string;
  }
  return string.replaceRange(0, 1, string[0].toLowerCase());
}

Map<String, dynamic> keysToLowerCase(Map<String, dynamic> map) {
  var outMap = <String,dynamic>{};
  map.forEach((key, value) {
    if (value is Map) {
      outMap[firstCharToLowerCase(key)] = keysToLowerCase(value);
    } else {
      outMap[firstCharToLowerCase(key)] = value;
    }
  });
  return outMap;
}

Map<String, dynamic> keysToUpperCase(Map<String, dynamic> map) {
  var outMap = <String,dynamic>{};
  map.forEach((key, value) {
    if (value is Map) {
      outMap[firstCharToUpperCase(key)] = keysToUpperCase(value);
    } else {
      outMap[firstCharToUpperCase(key)] = value;
    }
  });
  return outMap;
}

String firstCharToUpperCase(String string) {
  if (string.isEmpty) {
    return string;
  }
  return string.replaceRange(0, 1, string[0].toUpperCase());
}
