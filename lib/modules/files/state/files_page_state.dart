import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/models/file_group.dart';
import 'package:aurorafiles/models/file_to_delete.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
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
  final FilesDao _filesDao = DI.get();
  final _filesLocal = FilesLocalStorage();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String pagePath = "";
  List<LocalFile> currentFiles = [];
  List<FileGroup> searchResult = [];

  @observable
  Map<String, LocalFile> selectedFilesIds = {};

  @observable
  bool isSearchMode = false;

  String? searchText;

  bool isInsideZip = false;

  @observable
  FilesLoadingType filesLoading = FilesLoadingType.none;

  void selectFile(LocalFile? file) {
    if (file == null) return;
    // reassigning to update the observable
    final selectedIds = selectedFilesIds;
    if (selectedFilesIds[file.id] != null) {
      selectedIds.remove(file.id);
    } else {
      selectedIds[file.id] = file;
    }
    selectedFilesIds = selectedIds;
  }

  void quitSelectMode() {
    selectedFilesIds = {};
  }

  Future<void> onGetFiles({
    String? path,
    FilesLoadingType showLoading = FilesLoadingType.filesVisible,
    String? searchPattern,
    Function(String)? onError,
    bool afterRename = false,
  }) async {
    final actualPath = afterRename ? null : path;
    final actualSearch = afterRename ? searchText : searchPattern;

    if (AppStore.filesState.isOfflineMode) {
      await _getOfflineFiles(showLoading, actualPath, actualSearch, onError);
    } else {
      await _getOnlineFiles(showLoading, actualPath, actualSearch, onError);
    }
    searchText = actualSearch;
    _updateSearchResult();
  }

  Future _getOnlineFiles(
    FilesLoadingType showLoading,
    String? path,
    String? searchPattern,
    Function(String)? onError,
  ) async {
    try {
      filesLoading = showLoading;
      final response = await _filesApi.getFiles(
        StorageTypeHelper.toName(
          AppStore.filesState.selectedStorage.type,
        ),
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
              ConnectivityResult.none &&
          onError != null) {
        onError(err.toString());
      }
    } finally {
      filesLoading = FilesLoadingType.none;
    }
  }

  Future<void> _getOfflineFiles(
    FilesLoadingType showLoading,
    String? path,
    String? searchPattern,
    Function(String)? onError,
  ) async {
    AppStore.filesState.quota = null;
    try {
      filesLoading = showLoading;
      if (searchPattern != null) {
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
    List<LocalFile> filesToSort = List.from(list);
    filesToSort.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    List<LocalFile> folders = [];
    List<LocalFile> files = [];
    try {
      folders = filesToSort.where((file) => file.isFolder).toList();
    } catch (err) {
      print(err);
    }
    try {
      files = filesToSort.where((file) => !file.isFolder).toList();
    } catch (err) {
      print(err);
    }
    return [...folders, ...files];
  }

  List<LocalFile> _addFakeUploadFiles(List<LocalFile> list) {
    List<LocalFile> filesFromServer = List.from(list);
    try {
      final uploadingFiles = AppStore.filesState.processedFiles
          .where((process) => process.processingType == ProcessingType.upload);
      uploadingFiles.forEach((process) {
        final localFile = getFakeLocalFileForUploadProgress(process, pagePath);
        filesFromServer.add(localFile);
      });
      return filesFromServer;
    } catch (err) {
      return list;
    }
  }

  // supports both extracting files from selected ids and passing file(s) directly
  Future<void> onDeleteFiles({
    List<LocalFile>? filesToDelete,
    required Storage storage,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    final List<Map<String, dynamic>> mappedFilesToDelete = [];
    // files, that are deleted from direct mode are automatically deleted from offline
    final List<LocalFile> filesToDeleteLocally = [];
    final List<LocalFile> filesToDeleteFromCache = [];

    if (filesToDelete?.isNotEmpty == true) {
      filesToDelete?.forEach((file) {
        if (file.localPath.isNotEmpty) filesToDeleteLocally.add(file);
        filesToDeleteFromCache.add(file);
        mappedFilesToDelete.add(FileToDelete(
                path: file.path, name: file.name, isFolder: file.isFolder)
            .toMap());
      });
    } else {
      // find selected files by their id
      currentFiles.forEach((file) {
        if (selectedFilesIds[file.id] != null) {
          if (file.localPath.isNotEmpty) filesToDeleteLocally.add(file);
          filesToDeleteFromCache.add(file);
          mappedFilesToDelete.add(FileToDelete(
                  path: file.path, name: file.name, isFolder: file.isFolder)
              .toMap());
        }
      });
    }

    try {
      filesLoading = FilesLoadingType.filesVisible;
      await _filesApi.delete(
        StorageTypeHelper.toName(storage.type),
        pagePath,
        mappedFilesToDelete,
      );
      await _filesLocal.deleteFilesFromCache(files: filesToDeleteFromCache);
      await _filesDao.deleteFiles(filesToDeleteLocally);
      onSuccess();
    } catch (stack, err) {
      onError(err.toString());
      filesLoading = FilesLoadingType.none;
    }
  }

  void onCreateNewFolder({
    required String folderName,
    required Storage storage,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await _filesApi.createFolder(
        StorageTypeHelper.toName(storage.type),
        pagePath,
        folderName,
      );
      onSuccess();
    } catch (err) {
      onError(err.toString());
    }
  }

  void _updateSearchResult() {
    searchResult.clear();
    if (currentFiles.isEmpty) {
      return;
    }
    //group files by path
    final Map<String, List<int>> groupMap = {};
    for (var i = 0; i < currentFiles.length; i++) {
      final path = currentFiles[i].path;
      if (groupMap.containsKey(path)) {
        groupMap[path]?.add(i);
      } else {
        groupMap[path] = [i];
      }
    }
    //sort paths by levels
    final pathArr = [...groupMap.keys.toList()];
    pathArr.sort((String a, String b) {
      final aLevel = a.split('/').length;
      final bLevel = b.split('/').length;
      if (aLevel == bLevel) {
        return a.compareTo(b);
      } else {
        return aLevel.compareTo(bLevel);
      }
    });
    //filling in search results in sorted order
    for (var groupPath in pathArr) {
      final indexArr = groupMap[groupPath] ?? [];
      final groupFiles = <LocalFile>[];
      for (var index in indexArr) {
        groupFiles.add(currentFiles[index]);
      }
      searchResult.add(
        FileGroup(
          path: groupPath,
          files: groupFiles,
        ),
      );
    }
  }
}
