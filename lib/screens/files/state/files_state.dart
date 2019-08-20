import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/file_to_delete.dart';
import 'package:aurorafiles/models/file_to_move.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/screens/files/repository/files_api.dart';
import 'package:aurorafiles/screens/files/repository/files_local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

enum FilesLoadingType {
  none,
  filesVisible,
  filesHidden,
}

enum Modes {
  none,
  select,
  move,
  search,
}

abstract class _FilesState with Store {
  final _filesApi = FilesApi();
  final _filesLocal = FilesLocalStorage();

  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final filesTileLeadingSize = 48.0;

  List<File> currentFiles = [];
  List<Storage> currentStorages = [];

  @observable
  Storage selectedStorage =
      new Storage(type: "", displayName: "", isExternal: false);

  @observable
  Set<String> selectedFilesIds = new Set();

  @observable
  String currentPath = "";

  @observable
  FilesLoadingType filesLoading = FilesLoadingType.none;

  @observable
  Modes mode = Modes.none;

  List<File> filesToMoveCopy = [];

  void enableMoveMode([List<File> filesToBufferForMoving]) {
    filesToMoveCopy = [];

    if (filesToBufferForMoving is List<File>) {
      filesToMoveCopy = filesToBufferForMoving;
    } else if (selectedFilesIds.length > 0) {
      currentFiles.forEach((file) {
        if (selectedFilesIds.contains(file.id)) filesToMoveCopy.add(file);
      });
    } else
      throw Exception("No files to buffer for moving/copying");

    quitSelectMode();
    mode = Modes.move;
  }

  void disableMoveMode() {
    filesToMoveCopy = new List();
    mode = Modes.none;
  }

  void enableSearchMode() {
    mode = Modes.search;
  }

  void disableSearchMode() {
    mode = Modes.none;
  }

  void selectFile(String id) {
    // reassigning to update the observable
    final selectedIds = selectedFilesIds;
    if (selectedFilesIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    selectedFilesIds = selectedIds;
    if (selectedFilesIds.length <= 0) mode = Modes.none;
    else if (mode != Modes.select) mode = Modes.select;
  }

  void quitSelectMode() {
    selectedFilesIds = new Set();
    mode = Modes.none;
  }

  Future<void> onGetStorages({Function(String) onError}) async {
    try {
      currentStorages = await _filesApi.getStorages();
      if (currentStorages.length > 0) {
        selectedStorage = currentStorages[0];
      }
    } catch (err) {
      onError(err.toString());
    }
  }

  Future<void> onGetFiles({
    @required String path,
    FilesLoadingType showLoading = FilesLoadingType.filesVisible,
    String searchPattern = "",
    Function(String) onError,
  }) async {
    currentPath = path;
    try {
      filesLoading = showLoading;
      currentFiles = await _filesApi.getFiles(
          selectedStorage.type, currentPath, searchPattern);
    } catch (err) {
      onError(err.toString());
    } finally {
      filesLoading = FilesLoadingType.none;
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
          selectedStorage.type, currentPath, folderName);
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
      filesLoading = FilesLoadingType.filesVisible;
      await _filesApi.delete(
          selectedStorage.type, currentPath, mappedFilesToDelete);
      onSuccess();
    } catch (err) {
      onError(err.toString());
      filesLoading = FilesLoadingType.none;
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
        toType: selectedStorage.type,
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
          selectedStorage.type, currentPath, name, size, isFolder);
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
      await _filesApi.deletePublicLink(selectedStorage.type, currentPath, name);
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
