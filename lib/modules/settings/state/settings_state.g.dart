// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsState on _SettingsState, Store {
  final _$isDarkThemeAtom = Atom(name: '_SettingsState.isDarkTheme');

  @override
  bool get isDarkTheme {
    _$isDarkThemeAtom.context.enforceReadPolicy(_$isDarkThemeAtom);
    _$isDarkThemeAtom.reportObserved();
    return super.isDarkTheme;
  }

  @override
  set isDarkTheme(bool value) {
    _$isDarkThemeAtom.context.conditionallyRunInAction(() {
      super.isDarkTheme = value;
      _$isDarkThemeAtom.reportChanged();
    }, _$isDarkThemeAtom, name: '${_$isDarkThemeAtom.name}_set');
  }

  final _$isParanoidEncryptionEnabledAtom =
      Atom(name: '_SettingsState.isParanoidEncryptionEnabled');

  @override
  bool get isParanoidEncryptionEnabled {
    _$isParanoidEncryptionEnabledAtom.context
        .enforceReadPolicy(_$isParanoidEncryptionEnabledAtom);
    _$isParanoidEncryptionEnabledAtom.reportObserved();
    return super.isParanoidEncryptionEnabled;
  }

  @override
  set isParanoidEncryptionEnabled(bool value) {
    _$isParanoidEncryptionEnabledAtom.context.conditionallyRunInAction(() {
      super.isParanoidEncryptionEnabled = value;
      _$isParanoidEncryptionEnabledAtom.reportChanged();
    }, _$isParanoidEncryptionEnabledAtom,
        name: '${_$isParanoidEncryptionEnabledAtom.name}_set');
  }

  final _$encryptionKeysAtom = Atom(name: '_SettingsState.encryptionKeys');

  @override
  Map<String, String> get encryptionKeys {
    _$encryptionKeysAtom.context.enforceReadPolicy(_$encryptionKeysAtom);
    _$encryptionKeysAtom.reportObserved();
    return super.encryptionKeys;
  }

  @override
  set encryptionKeys(Map<String, String> value) {
    _$encryptionKeysAtom.context.conditionallyRunInAction(() {
      super.encryptionKeys = value;
      _$encryptionKeysAtom.reportChanged();
    }, _$encryptionKeysAtom, name: '${_$encryptionKeysAtom.name}_set');
  }

  final _$selectedKeyNameAtom = Atom(name: '_SettingsState.selectedKeyName');

  @override
  String get selectedKeyName {
    _$selectedKeyNameAtom.context.enforceReadPolicy(_$selectedKeyNameAtom);
    _$selectedKeyNameAtom.reportObserved();
    return super.selectedKeyName;
  }

  @override
  set selectedKeyName(String value) {
    _$selectedKeyNameAtom.context.conditionallyRunInAction(() {
      super.selectedKeyName = value;
      _$selectedKeyNameAtom.reportChanged();
    }, _$selectedKeyNameAtom, name: '${_$selectedKeyNameAtom.name}_set');
  }
}
