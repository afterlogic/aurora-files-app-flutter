import 'dart:convert';
import 'dart:io' as prefixDart;
import 'dart:io';
import 'dart:math';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/file_to_move.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/screens/files/repository/files_api.dart';
import 'package:aurorafiles/screens/files/repository/files_local_storage.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

// Global files state
abstract class _FilesState with Store {
  final _filesApi = FilesApi();
  final _filesLocal = FilesLocalStorage();

  final filesTileLeadingSize = 48.0;

  List<Storage> currentStorages = new List();

  @observable
  Storage selectedStorage =
      new Storage(type: "", displayName: "", isExternal: false);

  @observable
  bool isMoveModeEnabled = false;

  List<File> filesToMoveCopy = new List();

  // after moving files, both current page and the page files were moved from have to be updated
  // this cb updates the page the files were moved from
  Function({
    @required String path,
    @required Storage storage,
    Function(String) onError,
  }) updateFilesCb;

  void enableMoveMode({
    List<File> filesToMove,
    Set<String> selectedFileIds,
    List<File> currentFiles,
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
    try {
      currentStorages = await _filesApi.getStorages();
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
        updateFilesCb(path: filesToMoveCopy[0].path, storage: selectedStorage);
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

  Future onUploadFile({
    @required Function onUploadStart,
    @required Function onSuccess,
    @required Function(String) onError,
  }) async {
    // Pick 1 file since our back supports adding only 1 file at a time
    prefixDart.File file = await _filesLocal.pickFiles();
    String vector;

    if (file == null) return;

    final shouldEncrypt = selectedStorage.type == "encrypted";

    if (shouldEncrypt) {
      final encryptionData = await _encryptFile(file);
      file = encryptionData[0];
      vector = encryptionData[1];
    }
    // Get name and path
    final List<String> pathList = file.path.split("/");
    final name = pathList.last;
    pathList.removeLast();

    FileItem fileItem =
        new FileItem(filename: name, savedDir: pathList.join("/"));

    // Start uploading
    onUploadStart();
    final sub = _filesLocal.uploadFile(
      fileItems: [fileItem],
      storageType: selectedStorage.type,
      path: "",
      vector: shouldEncrypt ? vector : null,
    );

    // Subscribe to result
    sub.listen((result) {
      Map<String, dynamic> res = json.decode(result.response);
      if (res["Result"] == null || res["Result"] == false) {
        onError(getErrMsg(res));
      } else {
        if (shouldEncrypt) file.delete();
        onSuccess();
      }
    }, onError: (ex, stacktrace) {
      if (shouldEncrypt) file.delete();
      onError(ex.message);
    });
  }

  Future<List> _encryptFile(prefixDart.File file) async {
    final fileBytes = await file.readAsBytes();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final encryptedFile = new prefixDart.File(
      '${appDocDir.path}/${file.path.split("/").last}',
    );
    final createdFile = await encryptedFile.create();

    final key = prefixEncrypt.Key.fromBase16(
        "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef");
    // generate vector
    Random random = Random.secure();
    var values = List<int>.generate(16, (i) => random.nextInt(256));
    final iv = IV.fromBase64(base64Encode(values));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);
//    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    await createdFile.writeAsBytes(encrypted.bytes);
    return [createdFile, iv.base16];
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
      onError(err.toString());
    }
  }
}
