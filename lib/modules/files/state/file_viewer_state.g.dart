// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_viewer_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileViewerState on _FileViewerState, Store {
  final _$downloadProgressAtom =
      Atom(name: '_FileViewerState.downloadProgress');

  @override
  double get downloadProgress {
    _$downloadProgressAtom.context.enforceReadPolicy(_$downloadProgressAtom);
    _$downloadProgressAtom.reportObserved();
    return super.downloadProgress;
  }

  @override
  set downloadProgress(double value) {
    _$downloadProgressAtom.context.conditionallyRunInAction(() {
      super.downloadProgress = value;
      _$downloadProgressAtom.reportChanged();
    }, _$downloadProgressAtom, name: '${_$downloadProgressAtom.name}_set');
  }

  final _$decryptionProgressAtom =
      Atom(name: '_FileViewerState.decryptionProgress');

  @override
  double get decryptionProgress {
    _$decryptionProgressAtom.context
        .enforceReadPolicy(_$decryptionProgressAtom);
    _$decryptionProgressAtom.reportObserved();
    return super.decryptionProgress;
  }

  @override
  set decryptionProgress(double value) {
    _$decryptionProgressAtom.context.conditionallyRunInAction(() {
      super.decryptionProgress = value;
      _$decryptionProgressAtom.reportChanged();
    }, _$decryptionProgressAtom, name: '${_$decryptionProgressAtom.name}_set');
  }
}
