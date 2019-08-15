import 'package:aurorafiles/models/file_to_delete.dart';
import 'package:aurorafiles/models/files_type.dart';
import 'package:aurorafiles/screens/files/files_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

abstract class _FilesState with Store {
  final _repo = FilesRepository();

  final filesTileLeadingSize = 48.0;

  @observable
  List<dynamic> currentFiles;

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

  Future<void> onGetFiles(
      {@required String path, Function(String) onError}) async {
    currentPath = path;
    try {
      isFilesLoading = true;
      currentFiles = await _repo.getFiles(currentFilesType, currentPath, "");
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
      final String newFolderNameFromServer =
          await _repo.createFolder(currentFilesType, currentPath, folderName);
      onSuccess(newFolderNameFromServer);
    } catch (err) {
      onError(err.toString());
    }
  }

  Future onDeleteFiles({Function onSuccess, Function(String) onError}) async {
    final List<Map<String, dynamic>> filesToDelete = [];

    // find selected files by their id
    currentFiles.forEach((file) {
      if (selectedFilesIds.contains(file["Id"])) {
        final fileToDelete = FileToDelete(
            path: file["Path"], name: file["Name"], isFolder: file["IsFolder"]);
        filesToDelete.add(fileToDelete.toMap());
      }
    });

    try {
      isFilesLoading = true;
      await _repo.delete(currentFilesType, currentPath, filesToDelete);
      onSuccess();
    } catch (err) {
      onError(err.toString());
      isFilesLoading = false;
    }
  }
}
