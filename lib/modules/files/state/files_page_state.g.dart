// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_page_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilesPageState on _FilesPageState, Store {
  late final _$selectedFilesIdsAtom =
      Atom(name: '_FilesPageState.selectedFilesIds', context: context);

  @override
  Map<String, LocalFile> get selectedFilesIds {
    _$selectedFilesIdsAtom.reportRead();
    return super.selectedFilesIds;
  }

  @override
  set selectedFilesIds(Map<String, dynamic> value) {
    _$selectedFilesIdsAtom.reportWrite(value, super.selectedFilesIds, () {
      super.selectedFilesIds = value;
    });
  }

  late final _$isSearchModeAtom =
      Atom(name: '_FilesPageState.isSearchMode', context: context);

  @override
  bool get isSearchMode {
    _$isSearchModeAtom.reportRead();
    return super.isSearchMode;
  }

  @override
  set isSearchMode(bool value) {
    _$isSearchModeAtom.reportWrite(value, super.isSearchMode, () {
      super.isSearchMode = value;
    });
  }

  late final _$filesLoadingAtom =
      Atom(name: '_FilesPageState.filesLoading', context: context);

  @override
  FilesLoadingType get filesLoading {
    _$filesLoadingAtom.reportRead();
    return super.filesLoading;
  }

  @override
  set filesLoading(FilesLoadingType value) {
    _$filesLoadingAtom.reportWrite(value, super.filesLoading, () {
      super.filesLoading = value;
    });
  }

  @override
  String toString() {
    return '''
selectedFilesIds: ${selectedFilesIds},
isSearchMode: ${isSearchMode},
filesLoading: ${filesLoading}
    ''';
  }
}
