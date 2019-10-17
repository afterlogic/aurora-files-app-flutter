import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/models/file_to_delete.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../app_store.dart';

part 'files_page_state.g.dart';

enum FilesLoadingType {
  none,
  filesVisible,
  filesHidden,
}

class FilesPageState = _FilesPageState with _$FilesPageState;

// State instance per each files location
abstract class _FilesPageState with Store {
  final _filesApi = FilesApi();
  final _filesDao = FilesDao(AppStore.appDb);
  final _filesLocal = FilesLocalStorage();

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String pagePath = "";
  List<LocalFile> currentFiles = [];

  @observable
  Set<String> selectedFilesIds = new Set();

  @observable
  bool isSearchMode = false;

  bool isInsideZip = false;

  @observable
  FilesLoadingType filesLoading = FilesLoadingType.none;

  void selectFile(String id) {
    // reassigning to update the observable
    final selectedIds = selectedFilesIds;
    if (selectedFilesIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    selectedFilesIds = selectedIds;
  }

  void quitSelectMode() {
    selectedFilesIds = new Set();
  }

  Future<void> onGetFiles({
    String path,
    FilesLoadingType showLoading = FilesLoadingType.filesVisible,
    String searchPattern = "",
    Function(String) onError,
  }) async {
    if (AppStore.filesState.isOfflineMode) {
      return _getOfflineFiles(showLoading, path, searchPattern, onError);
    } else {
      return _getOnlineFiles(showLoading, path, searchPattern, onError);
    }
  }

  Future _getOnlineFiles(
    FilesLoadingType showLoading,
    String path,
    String searchPattern,
    Function(String) onError,
  ) async {
    try {
      filesLoading = showLoading;
      final response = await _filesApi.getFiles(
        AppStore.filesState.selectedStorage.type,
        path != null ? path : pagePath,
        searchPattern,
      );
      List<LocalFile> filesFromServer = response.items;
      AppStore.filesState.quota = response.quota;

      filesFromServer = _addFakeUploadFiles(filesFromServer);
      filesFromServer = _sortFiles(filesFromServer);
      final offlineFiles = await _filesDao.getFilesAtPath(pagePath);
      if (offlineFiles.isNotEmpty) {
        currentFiles = [];
        _sortFiles(filesFromServer);
        filesFromServer.forEach((apiFile) {
          try {
            final foundOfflineFile = offlineFiles.firstWhere((offlineFile) {
              return apiFile.id == offlineFile.id;
            });

            final morphedFile = apiFile.toJson();
            morphedFile["localId"] = foundOfflineFile.localId;
            morphedFile["localPath"] = foundOfflineFile.localPath;

            currentFiles.add(LocalFile.fromJson(morphedFile));
          } catch (err) {
            currentFiles.add(apiFile);
          }
        });
      } else {
        currentFiles = filesFromServer;
      }
    } catch (err) {
      if (!AppStore.filesState.isOfflineMode &&
          AppStore.settingsState.internetConnection !=
              ConnectivityResult.none) {
        onError(err.toString());
      }
    } finally {
      filesLoading = FilesLoadingType.none;
    }
  }

  Future<void> _getOfflineFiles(
    FilesLoadingType showLoading,
    String path,
    String searchPattern,
    Function(String) onError,
  ) async {
    AppStore.filesState.quota = null;
    try {
      filesLoading = showLoading;
      if (searchPattern != null && searchPattern.isNotEmpty) {
        currentFiles = await _filesDao.searchFiles(pagePath, searchPattern);
      } else {
        currentFiles = await _filesDao.getFilesAtPath(pagePath);
      }
    } catch (err) {
      if (onError != null) onError(err.toString());
    } finally {
      filesLoading = FilesLoadingType.none;
    }
  }

  List<LocalFile> _sortFiles(List<LocalFile> list) {
    List<LocalFile> filesToSort = new List.from(list);
    filesToSort.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    List<LocalFile> folders = [];
    List<LocalFile> files = [];
    try {
      folders = filesToSort.where((file) => file.isFolder).toList();
    } catch(err) {}
    try {
      files = filesToSort.where((file) => !file.isFolder).toList();
    } catch(err) {}
    return [...folders, ...files];
  }

  List<LocalFile> _addFakeUploadFiles(List<LocalFile> list) {
    List<LocalFile> filesFromServer = new List.from(list);
    try {
      final uploadingFiles = AppStore.filesState.processedFiles.where((
          process) => process.processingType == ProcessingType.upload);
      uploadingFiles.forEach((process) {
        final localFile = getFakeLocalFileForUploadProgress(process, pagePath);
        filesFromServer.add(localFile);
      });
      return filesFromServer;
    } catch(err) {
      return list;
    }
  }

  // supports both extracting files from selected ids and passing file(s) directly
  void onDeleteFiles({
    List<LocalFile> filesToDelete,
    @required Storage storage,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    final List<Map<String, dynamic>> mappedFilesToDelete = [];
    // files, that are deleted from direct mode are automatically deleted from offline
    final List<LocalFile> filesToDeleteLocally = [];
    final List<LocalFile> filesToDeleteFromCache = [];

    if (filesToDelete is List) {
      filesToDelete.forEach((file) {
        if (file.localPath != null) filesToDeleteLocally.add(file);
        filesToDeleteFromCache.add(file);
        mappedFilesToDelete.add(FileToDelete(
                path: file.path, name: file.name, isFolder: file.isFolder)
            .toMap());
      });
    } else {
      // find selected files by their id
      currentFiles.forEach((file) {
        if (selectedFilesIds.contains(file.id)) {
          if (file.localPath != null) filesToDeleteLocally.add(file);
          filesToDeleteFromCache.add(file);
          mappedFilesToDelete.add(FileToDelete(
                  path: file.path, name: file.name, isFolder: file.isFolder)
              .toMap());
        }
      });
    }

    try {
      filesLoading = FilesLoadingType.filesVisible;
      await _filesApi.delete(storage.type, pagePath, mappedFilesToDelete);
      await _filesLocal.deleteFilesFromCache(files: filesToDeleteFromCache);
      await _filesDao.deleteFiles(filesToDeleteLocally);
      onSuccess();
    } catch (stack, err) {
      onError(err.toString());
      filesLoading = FilesLoadingType.none;
    }
  }

  void onCreateNewFolder({
    @required String folderName,
    @required Storage storage,
    Function(String) onSuccess,
    Function(String) onError,
  }) async {
    try {
      final String newFolderNameFromServer =
          await _filesApi.createFolder(storage.type, pagePath, folderName);
      onSuccess(newFolderNameFromServer);
    } catch (err) {
      onError(err.toString());
    }
  }
}
