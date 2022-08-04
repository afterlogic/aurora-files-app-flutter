// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_viewer_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FileViewerState on _FileViewerState, Store {
   final _$downloadProgressAtom =
      Atom(name: '_FileViewerState.downloadProgress');

  @override
  double get downloadProgress {
    _$downloadProgressAtom.reportRead();
    return super.downloadProgress;
  }

  @override
  set downloadProgress(double value) {
    _$downloadProgressAtom.reportWrite(value, super.downloadProgress, () {
      super.downloadProgress = value;
    });
  }

   final _$fileWithContentsAtom =
      Atom(name: '_FileViewerState.fileWithContents');

  @override
  File get fileWithContents {
    _$fileWithContentsAtom.reportRead();
    return super.fileWithContents;
  }

  @override
  set fileWithContents(File value) {
    _$fileWithContentsAtom.reportWrite(value, super.fileWithContents, () {
      super.fileWithContents = value;
    });
  }

  @override
  String toString() {
    return '''
downloadProgress: ${downloadProgress},
fileWithContents: ${fileWithContents}
    ''';
  }
}
