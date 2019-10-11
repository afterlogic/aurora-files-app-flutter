import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/models/file_to_move.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

// Global files state
abstract class _FilesState with Store {
  final _filesApi = FilesApi();
  final _filesLocal = FilesLocalStorage();
  final _filesDao = FilesDao(AppStore.appDb);

  final filesTileLeadingSize = 48.0;

  final List<String> folderNavStack = new List();

  bool isOfflineMode = false;

  @observable
  List<Storage> currentStorages = new List();

  @observable
  Storage selectedStorage = new Storage(
      type: "",
      displayName: "",
      isExternal: false,
      isDroppable: false,
      order: 0);

  @observable
  bool isMoveModeEnabled = false;

  List<LocalFile> filesToMoveCopy = new List();

  // after moving files, both current page and the page files were moved from have to be updated
  // this cb updates the page the files were moved from
  Function({
    String path,
    Function(String) onError,
  }) updateFilesCb;

  void toggleOffline(bool val) {
    currentStorages = new List();
    isOfflineMode = val;
  }

  void enableMoveMode({
    List<LocalFile> filesToMove,
    Set<String> selectedFileIds,
    List<LocalFile> currentFiles,
  }) {
    if (filesToMove != null)
      filesToMoveCopy = filesToMove;
    else {
      filesToMoveCopy = [];
      currentFiles.forEach((file) {
        if (selectedFileIds.contains(file.id)) filesToMoveCopy.add(file);
      });
    }
    isMoveModeEnabled = true;
  }

  void disableMoveMode() {
    filesToMoveCopy = new List();
    isMoveModeEnabled = false;
  }

  Future<void> onGetStorages({Function(String) onError}) async {
    if (isOfflineMode) {
      await _getOfflineStorages(onError);
    } else {
      await _getOnlineStorages(onError);
    }
  }

  Future _getOnlineStorages(Function(String) onError) async {
    try {
      currentStorages = await _filesApi.getStorages();
      currentStorages.sort((a, b) => a.order.compareTo(b.order));
      if (currentStorages.length > 0) {
        selectedStorage = currentStorages[0];
      }
    } catch (err) {
      if (!isOfflineMode &&
          AppStore.settingsState.internetConnection !=
              ConnectivityResult.none) {
        onError(err.toString());
      }
    }
  }

  Future<void> _getOfflineStorages(Function(String) onError) async {
    try {
      currentStorages = await _filesDao.getStorages();
      if (currentStorages.length > 0) {
        selectedStorage = currentStorages[0];
      }
    } catch (err) {
      onError(err.toString());
    }
  }

//  void onLevelUp(Function getNewFiles) {
//    final List<String> pathArray = currentPath.split("/");
//    pathArray.removeLast();
//    currentPath = pathArray.join("/");
//    getNewFiles();
//  }

  // supports both extracting files from selected ids and passing file(s) directly
  Future onCopyMoveFiles({
    @required bool copy,
    @required String toPath,
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
        toPath: toPath,
      );
      onSuccess();
      if (updateFilesCb != null &&
          !copy &&
          selectedStorage.type == filesToMoveCopy[0].type) {
        updateFilesCb(path: filesToMoveCopy[0].path);
      }
    } catch (err) {
      onError(err.toString());
    }
  }

  Future onGetPublicLink({
    @required String name,
    @required int size,
    @required bool isFolder,
    @required String path,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    try {
      final String link = await _filesApi.createPublicLink(
          selectedStorage.type, path, name, size, isFolder);
      Clipboard.setData(ClipboardData(text: link));
      onSuccess();
    } catch (err) {
      onError(err.toString());
    }
  }

  Future onDeletePublicLink({
    @required String name,
    @required String path,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    try {
      await _filesApi.deletePublicLink(selectedStorage.type, path, name);
      onSuccess();
    } catch (err) {
      onError(err.toString());
    }
  }

  Future onRename({
    @required LocalFile file,
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

  Future onUploadFile({
    @required String path,
    @required Function onUploadStart,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    // Pick 1 file since our back supports adding only 1 file at a time
    File file = await _filesLocal.pickFiles();
    String vector;

    if (file == null) return;

    final shouldEncrypt = selectedStorage.type == "encrypted";

//    if (shouldEncrypt) {
//      onEncryptionStart();
//      final encryptionData = await _filesLocal.encryptFile(file);
//      file = encryptionData[0];
//      vector = encryptionData[1];
//    }
    // Get name
//    final name = FileUtils.getFileNameFromPath(file.path);

//    FileItem fileItem =
//        new FileItem(filename: name, savedDir: file.parent.path);

    // Start uploading
    onUploadStart();

    try {
      await _filesApi.uploadFile(
        file,
        shouldEncrypt,
        storageType: selectedStorage.type,
        path: path,
        onSuccess: onSuccess,
        onError: onError,
      );
    } catch (err) {
      onError(err.toString());
    }

//    // Subscribe to result
//    sub.listen((result) {
//      Map<String, dynamic> res = json.decode(result.response);
//      if (res["Result"] == null || res["Result"] == false) {
//        onError(getErrMsg(res));
//      } else {
//        if (shouldEncrypt && file.existsSync()) file.delete();
//        onSuccess();
//      }
//    }, onError: (ex, stacktrace) {
//      if (shouldEncrypt && file.existsSync()) file.delete();
//      onError(ex.message);
//    });
  }

  void onDownloadFile({
    LocalFile file,
    Function onStart,
    Function onUpdateProgress,
    Function onSuccess,
    Function onError,
  }) async {
    try {
      if (file.initVector != null &&
          AppStore.settingsState.currentKey == null) {
        throw CustomException("You need an encryption key to download files.");
      }
      // else
      onStart();
      final fileToDownloadInto =
          await _filesLocal.createFileForDownloadAndroid(file);
      await _filesApi.getFileContentsFromServer(
          file.downloadUrl, file, fileToDownloadInto, true,
          onSuccess: onSuccess, updateProgress: onUpdateProgress);
    } catch (err) {
      onError(err.toString());
    }
  }

  Future<void> onShareFile(
    LocalFile file, {
    File storedFile,
    Function(File) onSuccess,
    Function(int) updateProgress,
  }) async {
    File fileWithContents;
    if (storedFile == null) {
      final File tempFileForShare =
          await _filesLocal.createTempFile(file, useName: true);

      if (await tempFileForShare.length() <= 0) {
        await _filesApi.getFileContentsFromServer(
            file.downloadUrl, file, tempFileForShare, true,
            onSuccess: (File savedFile) {
          fileWithContents = savedFile;
          onSuccess(savedFile);
          _filesLocal.shareFile(fileWithContents, file);
        }, updateProgress: updateProgress);
      } else {
        fileWithContents = tempFileForShare;
        onSuccess(fileWithContents);
        _filesLocal.shareFile(fileWithContents, file);
      }
    } else {
      fileWithContents = storedFile;
      onSuccess(fileWithContents);
      _filesLocal.shareFile(fileWithContents, file);
    }
  }

  Future<void> onSetFileOffline(LocalFile file,
      {Function(int) updateProgress, Function() onSuccess}) async {
    if (file.localId == null) {
      final createdFileForOffline =
          await _filesLocal.createFileForOffline(file);
      await _filesApi.getFileContentsFromServer(
          file.downloadUrl, file, createdFileForOffline, false,
          onSuccess: (_) => onSuccess(), updateProgress: updateProgress);
      final FilesCompanion filesCompanion =
          getCompanionFromLocalFile(file, createdFileForOffline.path);
      await _filesDao.addFile(filesCompanion);
    } else {
      await _filesDao.deleteFiles([file]);
      onSuccess();
    }
  }

  Future<void> clearFilesToDeleteAndCancelDownload() async {
    final sub = FilesApi.downloadSubscription;
    final file = FilesApi.fileBeingLoaded;
    if (sub != null) await sub.cancel();
    if (file != null && await file.exists()) await file.delete();
    await _filesLocal.deleteFilesFromCache();
  }
}
