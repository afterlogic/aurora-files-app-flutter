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

  final _$selectedFilesIdsAtom = Atom(name: '_FilesState.selectedFilesIds');

  @override
  Set<String> get selectedFilesIds {
    _$selectedFilesIdsAtom.context.enforceReadPolicy(_$selectedFilesIdsAtom);
    _$selectedFilesIdsAtom.reportObserved();
    return super.selectedFilesIds;
  }

  @override
  set selectedFilesIds(Set<String> value) {
    _$selectedFilesIdsAtom.context.conditionallyRunInAction(() {
      super.selectedFilesIds = value;
      _$selectedFilesIdsAtom.reportChanged();
    }, _$selectedFilesIdsAtom, name: '${_$selectedFilesIdsAtom.name}_set');
  }

  final _$currentPathAtom = Atom(name: '_FilesState.currentPath');

  @override
  String get currentPath {
    _$currentPathAtom.context.enforceReadPolicy(_$currentPathAtom);
    _$currentPathAtom.reportObserved();
    return super.currentPath;
  }

  @override
  set currentPath(String value) {
    _$currentPathAtom.context.conditionallyRunInAction(() {
      super.currentPath = value;
      _$currentPathAtom.reportChanged();
    }, _$currentPathAtom, name: '${_$currentPathAtom.name}_set');
  }

  final _$filesLoadingAtom = Atom(name: '_FilesState.filesLoading');

  @override
  FilesLoadingType get filesLoading {
    _$filesLoadingAtom.context.enforceReadPolicy(_$filesLoadingAtom);
    _$filesLoadingAtom.reportObserved();
    return super.filesLoading;
  }

  @override
  set filesLoading(FilesLoadingType value) {
    _$filesLoadingAtom.context.conditionallyRunInAction(() {
      super.filesLoading = value;
      _$filesLoadingAtom.reportChanged();
    }, _$filesLoadingAtom, name: '${_$filesLoadingAtom.name}_set');
  }

  final _$modeAtom = Atom(name: '_FilesState.mode');

  @override
  Modes get mode {
    _$modeAtom.context.enforceReadPolicy(_$modeAtom);
    _$modeAtom.reportObserved();
    return super.mode;
  }

  @override
  set mode(Modes value) {
    _$modeAtom.context.conditionallyRunInAction(() {
      super.mode = value;
      _$modeAtom.reportChanged();
    }, _$modeAtom, name: '${_$modeAtom.name}_set');
  }
}
