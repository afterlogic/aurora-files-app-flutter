// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilesState on _FilesState, Store {
  final _$selectedStorageAtom = Atom(name: '_FilesState.selectedStorage');

  @override
  Storage get selectedStorage {
    _$selectedStorageAtom.context.enforceReadPolicy(_$selectedStorageAtom);
    _$selectedStorageAtom.reportObserved();
    return super.selectedStorage;
  }

  @override
  set selectedStorage(Storage value) {
    _$selectedStorageAtom.context.conditionallyRunInAction(() {
      super.selectedStorage = value;
      _$selectedStorageAtom.reportChanged();
    }, _$selectedStorageAtom, name: '${_$selectedStorageAtom.name}_set');
  }

  final _$isMoveModeEnabledAtom = Atom(name: '_FilesState.isMoveModeEnabled');

  @override
  bool get isMoveModeEnabled {
    _$isMoveModeEnabledAtom.context.enforceReadPolicy(_$isMoveModeEnabledAtom);
    _$isMoveModeEnabledAtom.reportObserved();
    return super.isMoveModeEnabled;
  }

  @override
  set isMoveModeEnabled(bool value) {
    _$isMoveModeEnabledAtom.context.conditionallyRunInAction(() {
      super.isMoveModeEnabled = value;
      _$isMoveModeEnabledAtom.reportChanged();
    }, _$isMoveModeEnabledAtom, name: '${_$isMoveModeEnabledAtom.name}_set');
  }
}
