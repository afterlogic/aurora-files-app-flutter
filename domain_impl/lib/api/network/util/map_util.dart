String firstCharToLowerCase(String string) {
  if (string.isEmpty || string == null) {
    return string;
  }
  return string.replaceRange(0, 1, string[0].toLowerCase());
}

Map<String, dynamic> keysToLowerCase(Map<String, dynamic> map) {
  var outMap = <String, dynamic>{};
  map.forEach((key, value) {
    if (value is Map) {
      outMap[firstCharToLowerCase(key)] = keysToLowerCase(value);
    } else if (value is List) {
      outMap[firstCharToLowerCase(key)] = value.map((item) {
        if (item is Map) {
          return keysToLowerCase(item);
        } else {
          return item;
        }
      }).toList();
    } else {
      outMap[firstCharToLowerCase(key)] = value;
    }
  });
  return outMap;
}

Map<String, dynamic> keysToUpperCase(Map<String, dynamic> map) {
  var outMap = <String, dynamic>{};
  map.forEach((key, value) {
    if (value is Map) {
      outMap[firstCharToUpperCase(key)] = keysToUpperCase(value);
    } else if (value is List) {
      outMap[firstCharToUpperCase(key)] = value.map((item) {
        if (item is Map) {
          return keysToUpperCase(item);
        } else {
          return item;
        }
      }).toList();
    }
    {
      outMap[firstCharToUpperCase(key)] = value;
    }
  });
  return outMap;
}

String firstCharToUpperCase(String string) {
  if (string.isEmpty || string == null) {
    return string;
  }
  return string.replaceRange(0, 1, string[0].toUpperCase());
}
