import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/file_to_delete.dart';
import 'package:aurorafiles/models/file_to_move.dart';
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

  @observable
  bool isMoveModeEnabled = false;

  List<File> filesToMoveCopy = [];

  void enableMoveMode([List<File> filesToBufferForMoving]) {
    isMoveModeEnabled = true;
    filesToMoveCopy = [];

    if (filesToBufferForMoving is List<File>) {
      filesToMoveCopy = filesToBufferForMoving;
    } else if (selectedFilesIds.length > 0) {
      currentFiles.forEach((file) {
        if (selectedFilesIds.contains(file.id)) filesToMoveCopy.add(file);
      });
    } else
      throw Exception("No files to buffer for moving/copying");

    selectedFilesIds = new Set();
  }

  void disableMoveMode() {
    isMoveModeEnabled = false;
    filesToMoveCopy = new List();
  }

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

  // supports both extracting files from selected ids and passing file(s) directly
  void onDeleteFiles({
    List<File> filesToDelete,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    final List<Map<String, dynamic>> mappedFilesToDelete = [];

    if (filesToDelete is List) {
      filesToDelete.forEach((file) {
        mappedFilesToDelete.add(FileToDelete(
                path: file.path, name: file.name, isFolder: file.isFolder)
            .toMap());
      });
    } else {
      // find selected files by their id
      currentFiles.forEach((file) {
        if (selectedFilesIds.contains(file.id)) {
          mappedFilesToDelete.add(FileToDelete(
                  path: file.path, name: file.name, isFolder: file.isFolder)
              .toMap());
        }
      });
    }

    try {
      isFilesLoading = true;
      await _filesApi.delete(
          currentFilesType, currentPath, mappedFilesToDelete);
      onSuccess();
    } catch (err) {
      onError(err.toString());
      isFilesLoading = false;
    }
  }

  // supports both extracting files from selected ids and passing file(s) directly
  Future onCopyMoveFiles({
    @required bool copy,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    final List<Map<String, dynamic>> mappedFiles = [];

    filesToMoveCopy.forEach((file) {
      mappedFiles.add(FileToMove(
              type: file.type,
              path: file.path,
              name: file.name,
              isFolder: file.isFolder)
          .toMap());
    });

    try {
      await _filesApi.copyMoveFiles(
        copy: copy,
        files: mappedFiles,
        fromType: filesToMoveCopy[0].type,
        toType: currentFilesType,
        fromPath: filesToMoveCopy[0].path,
        toPath: currentPath,
      );
      onSuccess();
    } catch (err) {
      onError(err.toString());
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
