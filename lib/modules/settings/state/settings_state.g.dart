// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsState on _SettingsState, Store {
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

  final _$encryptionKeyNameAtom =
      Atom(name: '_SettingsState.encryptionKeyName');

  @override
  String get encryptionKeyName {
    _$encryptionKeyNameAtom.context.enforceReadPolicy(_$encryptionKeyNameAtom);
    _$encryptionKeyNameAtom.reportObserved();
    return super.encryptionKeyName;
  }

  @override
  set encryptionKeyName(String value) {
    _$encryptionKeyNameAtom.context.conditionallyRunInAction(() {
      super.encryptionKeyName = value;
      _$encryptionKeyNameAtom.reportChanged();
    }, _$encryptionKeyNameAtom, name: '${_$encryptionKeyNameAtom.name}_set');
  }

  final _$encryptionKeyAtom = Atom(name: '_SettingsState.encryptionKey');

  @override
  String get encryptionKey {
    _$encryptionKeyAtom.context.enforceReadPolicy(_$encryptionKeyAtom);
    _$encryptionKeyAtom.reportObserved();
    return super.encryptionKey;
  }

  @override
  set encryptionKey(String value) {
    _$encryptionKeyAtom.context.conditionallyRunInAction(() {
      super.encryptionKey = value;
      _$encryptionKeyAtom.reportChanged();
    }, _$encryptionKeyAtom, name: '${_$encryptionKeyAtom.name}_set');
  }
}
