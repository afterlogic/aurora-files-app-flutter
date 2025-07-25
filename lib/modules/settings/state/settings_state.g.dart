// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsState on _SettingsState, Store {
  late final _$internetConnectionAtom =
      Atom(name: '_SettingsState.internetConnection', context: context);

  @override
  ConnectivityResult? get internetConnection {
    _$internetConnectionAtom.reportRead();
    return super.internetConnection;
  }

  @override
  set internetConnection(ConnectivityResult? value) {
    _$internetConnectionAtom.reportWrite(value, super.internetConnection, () {
      super.internetConnection = value;
    });
  }

  late final _$isDarkThemeAtom =
      Atom(name: '_SettingsState.isDarkTheme', context: context);

  @override
  bool? get isDarkTheme {
    _$isDarkThemeAtom.reportRead();
    return super.isDarkTheme;
  }

  @override
  set isDarkTheme(bool? value) {
    _$isDarkThemeAtom.reportWrite(value, super.isDarkTheme, () {
      super.isDarkTheme = value;
    });
  }

  late final _$isParanoidEncryptionEnabledAtom = Atom(
      name: '_SettingsState.isParanoidEncryptionEnabled', context: context);

  @override
  bool get isParanoidEncryptionEnabled {
    _$isParanoidEncryptionEnabledAtom.reportRead();
    return super.isParanoidEncryptionEnabled;
  }

  @override
  set isParanoidEncryptionEnabled(bool value) {
    _$isParanoidEncryptionEnabledAtom
        .reportWrite(value, super.isParanoidEncryptionEnabled, () {
      super.isParanoidEncryptionEnabled = value;
    });
  }

  late final _$encryptionKeysAtom =
      Atom(name: '_SettingsState.encryptionKeys', context: context);

  @override
  Map<String, String> get encryptionKeys {
    _$encryptionKeysAtom.reportRead();
    return super.encryptionKeys;
  }

  @override
  set encryptionKeys(Map<String, String> value) {
    _$encryptionKeysAtom.reportWrite(value, super.encryptionKeys, () {
      super.encryptionKeys = value;
    });
  }

  late final _$selectedKeyNameAtom =
      Atom(name: '_SettingsState.selectedKeyName', context: context);

  @override
  String? get selectedKeyName {
    _$selectedKeyNameAtom.reportRead();
    return super.selectedKeyName;
  }

  @override
  set selectedKeyName(String? value) {
    _$selectedKeyNameAtom.reportWrite(value, super.selectedKeyName, () {
      super.selectedKeyName = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_SettingsState.selectedLanguage', context: context);

  @override
  Language? get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(Language? value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$_SettingsStateActionController =
      ActionController(name: '_SettingsState', context: context);

  @override
  void setLanguage(Language? language) {
    final _$actionInfo = _$_SettingsStateActionController.startAction(
        name: '_SettingsState.setLanguage');
    try {
      return super.setLanguage(language);
    } finally {
      _$_SettingsStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
internetConnection: ${internetConnection},
isDarkTheme: ${isDarkTheme},
isParanoidEncryptionEnabled: ${isParanoidEncryptionEnabled},
encryptionKeys: ${encryptionKeys},
selectedKeyName: ${selectedKeyName},
selectedLanguage: ${selectedLanguage}
    ''';
  }
}
