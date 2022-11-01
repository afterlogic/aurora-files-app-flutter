// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilesState on _FilesState, Store {
  late final _$currentStoragesAtom =
      Atom(name: '_FilesState.currentStorages', context: context);

  @override
  List<Storage> get currentStorages {
    _$currentStoragesAtom.reportRead();
    return super.currentStorages;
  }

  @override
  set currentStorages(List<Storage> value) {
    _$currentStoragesAtom.reportWrite(value, super.currentStorages, () {
      super.currentStorages = value;
    });
  }

  late final _$quotaAtom = Atom(name: '_FilesState.quota', context: context);

  @override
  Quota? get quota {
    _$quotaAtom.reportRead();
    return super.quota;
  }

  @override
  set quota(Quota? value) {
    _$quotaAtom.reportWrite(value, super.quota, () {
      super.quota = value;
    });
  }

  late final _$selectedStorageAtom =
      Atom(name: '_FilesState.selectedStorage', context: context);

  @override
  Storage get selectedStorage {
    _$selectedStorageAtom.reportRead();
    return super.selectedStorage;
  }

  @override
  set selectedStorage(Storage value) {
    _$selectedStorageAtom.reportWrite(value, super.selectedStorage, () {
      super.selectedStorage = value;
    });
  }

  late final _$isMoveModeEnabledAtom =
      Atom(name: '_FilesState.isMoveModeEnabled', context: context);

  @override
  bool get isMoveModeEnabled {
    _$isMoveModeEnabledAtom.reportRead();
    return super.isMoveModeEnabled;
  }

  @override
  set isMoveModeEnabled(bool value) {
    _$isMoveModeEnabledAtom.reportWrite(value, super.isMoveModeEnabled, () {
      super.isMoveModeEnabled = value;
    });
  }

  late final _$isShareUploadAtom =
      Atom(name: '_FilesState.isShareUpload', context: context);

  @override
  bool get isShareUpload {
    _$isShareUploadAtom.reportRead();
    return super.isShareUpload;
  }

  @override
  set isShareUpload(bool value) {
    _$isShareUploadAtom.reportWrite(value, super.isShareUpload, () {
      super.isShareUpload = value;
    });
  }

  @override
  String toString() {
    return '''
currentStorages: ${currentStorages},
quota: ${quota},
selectedStorage: ${selectedStorage},
isMoveModeEnabled: ${isMoveModeEnabled},
isShareUpload: ${isShareUpload}
    ''';
  }
}
