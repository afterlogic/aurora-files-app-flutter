import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/file_to_delete.dart';
import 'package:aurorafiles/models/files_type.dart';
import 'package:aurorafiles/screens/files/repository/files_api.dart';
import 'package:aurorafiles/screens/files/repository/files_local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

abstract class _FilesState with Store {
  final _filesApi = FilesApi();
  final _filesLocal = FilesLocalStorage();

  final filesTileLeadingSize = 48.0;

  List<File> currentFiles;

  @observable
  Set<String> selectedFilesIds = new Set();

  @observable
  String currentPath = "";

  @observable
  String currentFilesType = FilesType.personal;

  @observable
  bool isFilesLoading = false;

  void onSelectFile(String id) {
    // reassigning to update the observable
    final selectedIds = selectedFilesIds;
    if (selectedFilesIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    selectedFilesIds = selectedIds;
  }

  Future<void> onGetFiles({
    @required String path,
    bool showLoading = false,
    Function(String) onError,
  }) async {
    currentPath = path;
    try {
      if (showLoading) isFilesLoading = true;
      currentFiles =
          await _filesApi.getFiles(currentFilesType, currentPath, "");
    } catch (err) {
      print("VO: : ${err}");
      onError(err.toString());
    } finally {
      isFilesLoading = false;
    }
  }

  void onLevelUp(Function getNewFiles) {
    final List<String> pathArray = currentPath.split("/");
    pathArray.removeLast();
    currentPath = pathArray.join("/");
    getNewFiles();
  }

  void onCreateNewFolder({
    @required String folderName,
    Function(String) onSuccess,
    Function(String) onError,
  }) async {
    try {
      final String newFolderNameFromServer = await _filesApi.createFolder(
          currentFilesType, currentPath, folderName);
      onSuccess(newFolderNameFromServer);
    } catch (err) {
      onError(err.toString());
    }
  }

  void onDeleteFiles({Function onSuccess, Function(String) onError}) async {
    final List<Map<String, dynamic>> filesToDelete = [];

    // find selected files by their id
    currentFiles.forEach((file) {
      if (selectedFilesIds.contains(file.id)) {
        final fileToDelete = FileToDelete(
            path: file.path, name: file.name, isFolder: file.isFolder);
        filesToDelete.add(fileToDelete.toMap());
      }
    });

    try {
      isFilesLoading = true;
      await _filesApi.delete(currentFilesType, currentPath, filesToDelete);
      onSuccess();
    } catch (err) {
      onError(err.toString());
      isFilesLoading = false;
    }
  }

  Future onGetPublicLink({
    @required String name,
    @required int size,
    @required bool isFolder,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    try {
      final String link = await _filesApi.createPublicLink(
          currentFilesType, currentPath, name, size, isFolder);
      Clipboard.setData(ClipboardData(text: link));
      onSuccess();
    } catch (err) {
      onError(err.toString());
    }
  }

  Future onDeletePublicLink({
    @required String name,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    try {
      await _filesApi.deletePublicLink(currentFilesType, currentPath, name);
      onSuccess();
    } catch (err) {
      onError(err.toString());
    }
  }

  Future onRename({
    @required File file,
    @required String newName,
    @required Function onSuccess,
    @required Function onError,
  }) async {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      final newNameFromServer = await _filesApi.renameFile(
        type: file.type,
        path: file.path,
        name: file.name,
        newName: newName,
        isLink: file.isLink,
        isFolder: file.isFolder,
      );
      onSuccess(newNameFromServer);
    } catch (err) {
      onError(err.toString());
    }
  }

  void onDownloadFile({
    String url,
    String fileName,
    Function onStart,
    Function onSuccess,
    Function onError,
  }) async {
    try {
      onStart();
      await _filesLocal.downloadFile(url, fileName);
      _filesLocal.getDownloadStatus(onSuccess);
    } catch (err) {
      onError(err);
    }
  }
}
