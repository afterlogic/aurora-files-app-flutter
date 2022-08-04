// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsState on _SettingsState, Store {
   final _$internetConnectionAtom =
      Atom(name: '_SettingsState.internetConnection');

  @override
  ConnectivityResult get internetConnection {
    _$internetConnectionAtom.reportRead();
    return super.internetConnection;
  }

  @override
  set internetConnection(ConnectivityResult value) {
    _$internetConnectionAtom.reportWrite(value, super.internetConnection, () {
      super.internetConnection = value;
    });
  }

   final _$isDarkThemeAtom =
      Atom(name: '_SettingsState.isDarkTheme');

  @override
  bool get isDarkTheme {
    _$isDarkThemeAtom.reportRead();
    return super.isDarkTheme;
  }

  @override
  set isDarkTheme(bool value) {
    _$isDarkThemeAtom.reportWrite(value, super.isDarkTheme, () {
      super.isDarkTheme = value;
    });
  }

   final _$isParanoidEncryptionEnabledAtom = Atom(
      name: '_SettingsState.isParanoidEncryptionEnabled');

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

   final _$encryptionKeysAtom =
      Atom(name: '_SettingsState.encryptionKeys');

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

   final _$selectedKeyNameAtom =
      Atom(name: '_SettingsState.selectedKeyName');

  @override
  String get selectedKeyName {
    _$selectedKeyNameAtom.reportRead();
    return super.selectedKeyName;
  }

  @override
  set selectedKeyName(String value) {
    _$selectedKeyNameAtom.reportWrite(value, super.selectedKeyName, () {
      super.selectedKeyName = value;
    });
  }

  @override
  String toString() {
    return '''
internetConnection: ${internetConnection},
isDarkTheme: ${isDarkTheme},
isParanoidEncryptionEnabled: ${isParanoidEncryptionEnabled},
encryptionKeys: ${encryptionKeys},
selectedKeyName: ${selectedKeyName}
    ''';
  }
}
