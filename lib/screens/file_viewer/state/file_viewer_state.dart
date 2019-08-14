import 'package:aurorafiles/screens/file_viewer/file_viewer_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'file_viewer_state.g.dart';

class FileViewerState = _FileViewerState with _$FileViewerState;

abstract class _FileViewerState with Store {
  final _repo = FileViewerRepository();

  @observable
  String fileName;

  void onDownloadFile({
    String url,
    String fileName,
    Function onStart,
    Function onSuccess,
    Function onError,
  }) async {
    try {
      onStart();
      await _repo.downloadFile(url, fileName);
      _repo.getDownloadStatus(onSuccess);
    } catch (err) {
      onError(err);
    }
  }

  Future onRename({
    @required String type,
    @required String path,
    @required String name,
    @required String newName,
    @required bool isLink,
    @required bool isFolder,
    @required bool isFormValid,
    @required Function onSuccess,
    @required Function onError,
  }) async {
    if (!isFormValid) return;

    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      final newNameFromServer = await _repo.renameFile(
        type: type,
        path: path,
        name: name,
        newName: newName,
        isLink: isLink,
        isFolder: isFolder,
      );
      onSuccess(newNameFromServer);
    } catch (err) {
      onError(err.toString());
    }
  }
}
