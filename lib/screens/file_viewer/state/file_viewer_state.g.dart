// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_viewer_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$FileViewerState on _FileViewerState, Store {
  final _$fileNameAtom = Atom(name: '_FileViewerState.fileName');

  @override
  String get fileName {
    _$fileNameAtom.context.enforceReadPolicy(_$fileNameAtom);
    _$fileNameAtom.reportObserved();
    return super.fileName;
  }

  @override
  set fileName(String value) {
    _$fileNameAtom.context.conditionallyRunInAction(() {
      super.fileName = value;
      _$fileNameAtom.reportChanged();
    }, _$fileNameAtom, name: '${_$fileNameAtom.name}_set');
  }
}
