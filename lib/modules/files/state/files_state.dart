import 'dart:async';
import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/models/file_to_move.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

final dummyStorage = new Storage(
    type: "", displayName: "", isExternal: false, isDroppable: false, order: 0);

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
  Storage selectedStorage = dummyStorage;

  List<ProcessingFile> processedFiles = new List();

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
    @required Function(ProcessingFile) onUploadStart,
    @required Function() onSuccess,
    @required Function(String) onError,
  }) async {
    // Pick 1 file since our back supports adding only 1 file at a time
    File file = await _filesLocal.pickFiles();

    if (file == null) return;

    final shouldEncrypt = selectedStorage.type == "encrypted";

    final fileName = FileUtils.getFileNameFromPath(file.path);
    final localFile = new LocalFile(
      localId: null,
      id: fileName,
      guid: Uuid().v4(),
      type: null,
      path: path,
      fullPath: path + fileName,
      localPath: file.path,
      name: fileName,
      size: file.lengthSync(),
      isFolder: false,
      isOpenable: false,
      isLink: false,
      linkType: null,
      linkUrl: null,
      lastModified: null,
      contentType: null,
      oEmbedHtml: null,
      published: null,
      owner: AppStore.authState.userEmail,
      content: null,
      viewUrl: null,
      downloadUrl: null,
      thumbnailUrl: null,
      hash: null,
      extendedProps: "[]",
      isExternal: null,
      initVector: null,
    );

    final processingFile = addFileToProcessing(
      localFile,
      file,
      ProcessingType.upload,
      null,
    );
    onUploadStart(processingFile);

    try {
      await _filesApi.uploadFile(
        processingFile,
        shouldEncrypt,
        storageType: selectedStorage.type,
        path: path,
        onSuccess: () {
          deleteFromProcessing(processingFile.guid);
          onSuccess();
        },
        onError: (err) {
          deleteFromProcessing(processingFile.guid);
          onError(err.toString());
        },
      );
    } catch (err, s) {
      deleteFromProcessing(processingFile.guid);
      onError(err.toString());
    }
  }

  void onDownloadFile({
    LocalFile file,
    Function(ProcessingFile) onStart,
    Function(File) onSuccess,
    Function(String) onError,
  }) async {
    try {
      if (file.initVector != null &&
          AppStore.settingsState.currentKey == null) {
        throw CustomException("You need an encryption key to download files.");
      }
      if (_isFileIsBeingProcessed(file.guid)) {
        throw CustomException("This file is occupied with another operation.");
      }

      // if file exists in cache, just copy it to downloads folder
      final Directory dir = await DownloadsPathProvider.downloadsDirectory;
      final File copiedFile =
          await _filesLocal.copyFromCache(file, "${dir.path}/${file.name}");
      if (copiedFile != null && file.size == copiedFile.lengthSync()) {
        onSuccess(copiedFile);
      } else {
        final fileToDownloadInto =
            await _filesLocal.createFileForDownloadAndroid(file);

        final processingFile = addFileToProcessing(
          file,
          fileToDownloadInto,
          ProcessingType.download,
          file.initVector,
        );

        onStart(processingFile);

        // ignore: cancel_subscriptions
        final sub = await _filesApi.getFileContentsFromServer(
          file.downloadUrl,
          file,
          processingFile,
          true,
          onSuccess: (File downloadedFile) {
            deleteFromProcessing(file.guid);
            onSuccess(downloadedFile);
          },
          onError: (err) {
            deleteFromProcessing(file.guid);
            onError(err);
          },
        );
        processingFile.subscription = sub;
      }
    } catch (err, s) {
      onError(err.toString());
    }
  }

  Future<void> onShareFile(
    LocalFile file, {
    File storedFile,
    Function(ProcessingFile) onStart,
    Function(File) onSuccess,
  }) async {
    if (_isFileIsBeingProcessed(file.guid)) {
      throw CustomException("This file is occupied with another operation.");
    }

    File fileWithContents;
    if (storedFile == null) {
      final File tempFileForShare =
          await _filesLocal.createTempFile(file, useName: true);

      final processingFile = addFileToProcessing(
          file, tempFileForShare, ProcessingType.share, file.initVector);
      if (await tempFileForShare.length() <= 0) {
        onStart(processingFile);
        // ignore: cancel_subscriptions
        final sub = await _filesApi.getFileContentsFromServer(
            file.downloadUrl, file, processingFile, true,
            onSuccess: (File savedFile) {
              fileWithContents = savedFile;
              deleteFromProcessing(file.guid);
              onSuccess(savedFile);
              _filesLocal.shareFile(fileWithContents, file);
            },
            onError: (err) => deleteFromProcessing(file.guid));
        processingFile.subscription = sub;
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
      {@required Function() onSuccess,
      @required Function(ProcessingFile) onStart,
      @required Function(String) onError}) async {
    if (_isFileIsBeingProcessed(file.guid)) {
      throw CustomException("This file is occupied with another operation.");
    }

    if (file.localId == null) {
      // if file exists in cache, just copy it to downloads folder
      final Directory dir = await getApplicationDocumentsDirectory();
      final offlineDir = "${dir.path}/offline/${file.guid}_${file.name}";
      File fileForOffline = await _filesLocal.copyFromCache(file, offlineDir);
      if (fileForOffline != null && fileForOffline.lengthSync() == file.size) {
        onSuccess();
      } else {
        fileForOffline = await _filesLocal.createFileForOffline(file);
        final processingFile = addFileToProcessing(
            file, fileForOffline, ProcessingType.offline, file.initVector);
        // ignore: cancel_subscriptions
        final sub = await _filesApi.getFileContentsFromServer(
            file.downloadUrl, file, processingFile, false,
            onSuccess: (_) {
              deleteFromProcessing(file.guid);
              onSuccess();
            },
            onError: (err) => deleteFromProcessing(file.guid));
        processingFile.subscription = sub;
        onStart(processingFile);
      }
      final FilesCompanion filesCompanion =
          getCompanionFromLocalFile(file, fileForOffline.path);
      await _filesDao.addFile(filesCompanion);
    } else {
      await _filesDao.deleteFiles([file]);
      onSuccess();
    }
  }

  bool _isFileIsBeingProcessed(String guid) {
    try {
      return processedFiles.firstWhere((file) => file.guid == guid) != null;
    } catch(err) {
      return false;
    }
  }

  ProcessingFile addFileToProcessing(
    LocalFile file,
    File deviceLocation,
    ProcessingType type,
    String iv) {
    ProcessingFile processingFile;
    // if exists
    try {
      processingFile =
          processedFiles.firstWhere((process) => process.guid == file.guid);
      return processingFile;
    } catch (err) {}

    // else
    processingFile = new ProcessingFile(
      guid: file.guid,
      name: file.name,
      size: file.size,
      fileOnDevice: deviceLocation,
      processingType: type,
    );

    processedFiles.add(processingFile);
    print("process added: ${processedFiles.length}");
    return processingFile;
  }

  void deleteFromProcessing(String guid, {bool deleteLocally = false}) {
    try {
      final fileToDelete = processedFiles.firstWhere((file) =>
      file.guid == guid);
      fileToDelete.endProcess();
      if (deleteLocally) fileToDelete.fileOnDevice.delete(recursive: true);
      processedFiles.removeWhere((file) => file.guid == guid);
      print("process removed: ${processedFiles.length}");
    } catch(err) {}
  }

  Future<void> clearCache({deleteCachedImages = false}) async {
    return _filesLocal.deleteFilesFromCache(
        deleteCachedImages: deleteCachedImages);
  }
}
