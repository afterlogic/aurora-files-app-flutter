import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/file_to_delete.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String pagePath = "";
  List<LocalFile> currentFiles = [];

  @observable
  Set<String> selectedFilesIds = new Set();

  @observable
  bool isSearchMode = false;

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
    try {
      filesLoading = showLoading;
      currentFiles = await _filesApi.getFiles(
        AppStore.filesState.selectedStorage.type,
        path != null ? path : pagePath,
        searchPattern,
      );
    } catch (err) {
      onError(err.toString());
    } finally {
      filesLoading = FilesLoadingType.none;
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
      await _filesApi.delete(storage.type, pagePath, mappedFilesToDelete);
      onSuccess();
    } catch (err) {
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
