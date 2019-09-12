// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_page_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilesPageState on _FilesPageState, Store {
  final _$selectedFilesIdsAtom = Atom(name: '_FilesPageState.selectedFilesIds');

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

  final _$isSearchModeAtom = Atom(name: '_FilesPageState.isSearchMode');

  @override
  bool get isSearchMode {
    _$isSearchModeAtom.context.enforceReadPolicy(_$isSearchModeAtom);
    _$isSearchModeAtom.reportObserved();
    return super.isSearchMode;
  }

  @override
  set isSearchMode(bool value) {
    _$isSearchModeAtom.context.conditionallyRunInAction(() {
      super.isSearchMode = value;
      _$isSearchModeAtom.reportChanged();
    }, _$isSearchModeAtom, name: '${_$isSearchModeAtom.name}_set');
  }

  final _$filesLoadingAtom = Atom(name: '_FilesPageState.filesLoading');

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
}
