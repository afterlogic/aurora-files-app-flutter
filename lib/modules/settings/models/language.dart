import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Language {
  final String name;
  final String tag;

  const Language(this.name, this.tag);

  // for language selection modal
  static List<Language?> get availableLanguages {
    final languages = <Language?>[];
    // null sets system default language
    languages.add(null);
    // Add supported languages
    languages.add(const Language("English", "en"));
    languages.add(const Language("Français", "fr"));
    languages.add(const Language("Deutsch", "de"));
    languages.add(const Language("Italiano", "it"));
    return languages;
  }

  Locale toLocale() {
    return Locale(tag);
  }

  String? toNullableJson() {
    return json.encode({
      "name": name,
      "tag": tag,
    });
  }

  static Language? fromJson(String? lang) {
    if (lang == null) {
      return null;
    } else {
      final decoded = json.decode(lang) as Map;
      return Language(decoded["name"] as String, decoded["tag"] as String);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.tag == tag && other.name == name;
  }

  @override
  int get hashCode => tag.hashCode ^ name.hashCode;
}
