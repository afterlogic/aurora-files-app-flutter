import 'dart:async';
import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/models/file_to_move.dart';
import 'package:aurorafiles/models/folder.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/quota.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/models/secure_link.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/dialogs/key_request_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/repository/mail_api.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:aurorafiles/utils/mail_template.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing/recive_sharing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

final dummyStorage = new Storage(
    type: "", displayName: "", isExternal: false, isDroppable: false, order: 0);

// Global files state
abstract class _FilesState with Store {
  final _filesApi = FilesApi();
  final _mailApi = MailApi();
  final _filesLocal = FilesLocalStorage();
  final FilesDao _filesDao = DI.get();

  final filesTileLeadingSize = 48.0;

  final List<String> folderNavStack = new List();

  bool isOfflineMode = false;

  @observable
  List<Storage> currentStorages = new List();

  @observable
  Quota quota;

  @observable
  Storage selectedStorage = dummyStorage;

  List<ProcessingFile> processedFiles = new List();

  @observable
  bool isMoveModeEnabled = false;

  @observable
  bool isShareUpload = false;

  List<SharedMediaFile> filesToShareUpload = List();
  List<LocalFile> filesToMoveCopy = new List();

  // after moving files, both current page and the page files were moved from have to be updated
  // this cb updates the page the files were moved from
  Function({
    String path,
    Function(String) onError,
  }) updateFilesCb;

  void toggleOffline(bool val) async {
    isOfflineMode = val;
    currentStorages = [];
    if (val == true) {
      _initOffline();
    }
  }

  _initOffline() async {
    final offlineStorages = <Storage>[];
    final storages = await _filesDao.getStorages();
    for (Storage storage in storages) {
      final files = await _filesDao.getFilesForStorage(storage.displayName);
      if (files.isNotEmpty) {
        offlineStorages.add(storage);
      }
    }
    currentStorages = offlineStorages;
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

  Future<void> refreshQuota() async {
    final response = await _filesApi.getFiles(
      AppStore.filesState.selectedStorage.type,
      "",
      "",
    );
    quota = response.quota;
  }

  Future<LocalFile> getFileFromServer(LocalFile file) {
    return _filesApi.getFiles(file.type, file.path, file.name).then(
          (value) => value.items.firstWhere(
            (element) => element.name == file.name,
            orElse: () => null,
          ),
        );
  }

  onUploadShared(List<SharedMediaFile> files) {
    isShareUpload = true;
    filesToShareUpload = files;
  }

  disableUploadShared() {
    filesToShareUpload = new List();
    isShareUpload = false;
  }

  uploadShared(
    BuildContext context, {
    String toPath,
    Function onSuccess,
    Function(String) onError,
  }) async {
    try {
      for (var item in filesToShareUpload) {
        File file;
        String name = item.name;

        if (item.isText) {
          name += ".txt";
          final dir = await getTemporaryDirectory();
          file = File(dir.path + Platform.pathSeparator + name);
          if (await file.exists()) {
            await file.delete();
          }
          await file.create();
          await file.writeAsString(item.text);
        } else {
          file = File(item.path);
        }
        await uploadFile(
          context,
          file: file,
          name: name,
          path: toPath,
          onUploadStart: (_) {},
          onSuccess: onSuccess,
          onError: onError,
          shouldEncrypt: selectedStorage.type == "encrypted",
        );
      }
    } catch (e) {}
    onSuccess();
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

  Future addDecryptedKey(
      BuildContext context, LocalFile file, List<String> contactKey) async {
    if (contactKey.isEmpty) {
      return _filesApi.updateKeyShared(file, null, []);
    }
    final password = await KeyRequestDialog.request(context);
    if (password == null) {
      throw "";
    }
    final key = (await PgpKeyUtil.instance
        .userDecrypt(file.encryptedDecryptionKey, password));
    return _filesApi.updateKeyShared(file, key, contactKey);
  }

  Future addDecryptedPublicKey(
      BuildContext context, LocalFile file, List<String> contactKey) async {
    final password = await KeyRequestDialog.request(context);
    if (password == null) {
      throw "";
    }
    final key = (await PgpKeyUtil.instance
        .userDecrypt(file.encryptedDecryptionKey, password));
    return _filesApi.updateExtendedPropsPublicKey(
        file,
        (await PgpKeyUtil.instance.encrypt(key, contactKey))
            .replaceAll("\n", "\r\n"));
  }

  Future addDecryptedPublicPassword(
      BuildContext context, LocalFile file, String password) async {
    return _filesApi.updateExtendedPropsPublicKey(file, password);
  }

  Future onGetPublicLink({
    @required String name,
    @required int size,
    @required bool isFolder,
    @required String path,
    @required Function(String) onSuccess,
    @required Function(String) onError,
  }) async {
    try {
      final String link = await _filesApi.createPublicLink(
          selectedStorage.type, path, name, size, isFolder);
      onSuccess(link);
    } catch (err) {
      onError(err.toString());
    }
  }

  Future onGetSecureLink({
    @required String name,
    @required int size,
    @required bool isFolder,
    @required String path,
    @required Function(SecureLink) onSuccess,
    @required Function(String) onError,
    @required String password,
    @required bool isKey,
    @required String email,
  }) async {
    try {
      final SecureLink result = await _filesApi.createSecureLink(
        selectedStorage.type,
        path,
        name,
        size,
        isFolder,
        password,
        isKey,
        email,
      );
      onSuccess(result);
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

  Future updateFile(FilesCompanion file) {
    return _filesDao.updateFile(file);
  }

  Future<void> onUploadFile(
    BuildContext context,
    Future<bool> Function(File) onSelect, {
    @required String path,
    @required Function(ProcessingFile) onUploadStart,
    @required Function() onSuccess,
    @required Function(String) onError,
  }) async {
    File file = await _filesLocal.pickFiles();
    if (file == null) return;
    final shouldEncrypt = await onSelect(file);
    if (shouldEncrypt == null) return;
    return uploadFile(
      context,
      file: file,
      path: path,
      onUploadStart: onUploadStart,
      onSuccess: onSuccess,
      onError: onError,
      shouldEncrypt: shouldEncrypt,
    );
  }

  Future<void> uploadFile(
    BuildContext context, {
    @required bool shouldEncrypt,
    @required File file,
    String name,
    @required String path,
    @required Function(ProcessingFile) onUploadStart,
    @required Function() onSuccess,
    @required Function(String) onError,
    String encryptionRecipientEmail,
    bool passwordEncryption,
    List<LocalPgpKey> addedPgpKey,
  }) async {
    final privateKey = await PgpKeyUtil.instance.userPrivateKey();
    String password;
    if (privateKey != null) {
      try {
        password = await KeyRequestDialog.request(context, forSign: true);
      } catch (e) {
        print(e);
      }
    }
    final fileName = name ?? FileUtils.getFileNameFromPath(file.path);
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
        name: name,
        passwordEncryption: passwordEncryption,
        storageType: selectedStorage.type,
        path: path,
        password: password,
        encryptionRecipientEmail: encryptionRecipientEmail,
        addedPgpKey: addedPgpKey,
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

  void onDownloadFile(
    BuildContext context, {
    LocalFile file,
    Function(ProcessingFile) onStart,
    Function(File) onSuccess,
    Function(String) onError,
  }) async {
    try {
      if ((file.initVector != null && file.encryptedDecryptionKey == null) &&
          AppStore.settingsState.currentKey == null) {
        throw CustomException("You need an encryption key to download files.");
      }
      if (file.encryptedDecryptionKey != null &&
          !(await PgpKeyUtil.instance.hasUserKey())) {
        throw CustomException("You need an encryption key to download files.");
      }
      if (_isFileIsBeingProcessed(file.guid)) {
        throw CustomException("This file is occupied with another operation.");
      }
      String password;
      if (file.encryptedDecryptionKey != null) {
        password = await KeyRequestDialog.request(context);
        if (password == null) {
          return;
        }
      }
      if (isOfflineMode) {
        try {
          final fileForDownload =
              await _filesLocal.createFileForDownloadAndroid(file);
          final processingFile = addFileToProcessing(
            file,
            fileForDownload,
            ProcessingType.download,
            file.initVector != null
                ? IV.fromBase16(file.initVector).base64
                : null,
          );
          onStart(processingFile);
          final downloadedFile =
              await _filesLocal.downloadOffline(file, processingFile, password);
          onSuccess(downloadedFile);
          deleteFromProcessing(file.guid);
        } catch (err) {
          deleteFromProcessing(file.guid);
          throw CustomException(err.toString());
        }
        return;
      }

      // if file exists in cache, just copy it to downloads folder
      final Directory dir = (await getExternalStorageDirectories(
              type: StorageDirectory.downloads))
          .first;
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
          password,
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
      deleteFromProcessing(file.guid);
    }
  }

  share(PreparedForShare preparedForShare) {
    _filesLocal.shareFile(preparedForShare.file, preparedForShare.localFile);
  }

  Future<void> prepareForShare(
    LocalFile file,
    BuildContext context, {
    File storedFile,
    Function(ProcessingFile) onStart,
    Function(PreparedForShare) onSuccess,
    Function(String) onError,
  }) async {
    try {
      String password;
      if (file.encryptedDecryptionKey != null) {
        password = await KeyRequestDialog.request(context);
        if (password == null) {
          return;
        }
      }
      if (_isFileIsBeingProcessed(file.guid)) {
        onError("This file is occupied with another operation.");
      }
      if (file.initVector != null &&
          !(await PgpKeyUtil.instance.hasUserKey())) {}
      await clearCache();

      if (isOfflineMode) {
        try {
          final tempFile =
              await _filesLocal.createTempFile(file, useName: true);
          final processingFile = addFileToProcessing(
            file,
            tempFile,
            ProcessingType.download,
            file.initVector != null
                ? IV.fromBase16(file.initVector).base64
                : null,
          );
          onStart(processingFile);
          final prepareForShare = await _filesLocal
              .shareOffline(file, processingFile, password)
              .catchError(onError);
          onSuccess(prepareForShare);
          deleteFromProcessing(file.guid);
        } catch (err) {
          deleteFromProcessing(file.guid);
          onError(err.toString());
          throw CustomException(err.toString());
        }
        return;
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
              file.downloadUrl, file, processingFile, true, password,
              onSuccess: (File savedFile) {
            fileWithContents = savedFile;
            onSuccess(PreparedForShare(fileWithContents, file));
            deleteFromProcessing(file.guid);
          }, onError: (err) {
            deleteFromProcessing(file.guid);
            onError(err);
          });
          processingFile.subscription = sub;
        } else {
          fileWithContents = tempFileForShare;
          onSuccess(PreparedForShare(fileWithContents, file));
        }
      } else {
        fileWithContents = storedFile;
        onSuccess(PreparedForShare(fileWithContents, file));
      }
    } catch (e) {
      onError(e);
    }
  }

  Future<void> onSetFileOffline(LocalFile file, BuildContext context,
      {@required Function() onSuccess,
      @required Function(ProcessingFile) onStart,
      @required Function(String) onError}) async {
    if (_isFileIsBeingProcessed(file.guid)) {
      throw CustomException("This file is occupied with another operation.");
    }

    if (file.localId == null) {
      // if file exists in cache, just copy it to downloads folder
      final Directory dir = await getApplicationDocumentsDirectory();
      final offlineDir =
          "${dir.path}/offline${file.path + (file.path.isNotEmpty ? "/" : "")}${file.guid}_${file.name}";
      File fileForOffline = await _filesLocal.copyFromCache(file, offlineDir);
      if (fileForOffline != null && fileForOffline.lengthSync() == file.size) {
        final FilesCompanion filesCompanion =
            getCompanionFromLocalFile(file, fileForOffline.path);
        await _filesDao.addFile(filesCompanion);
        onSuccess();
      } else {
        fileForOffline = await _filesLocal.createFileForOffline(file);
        final processingFile = addFileToProcessing(
            file, fileForOffline, ProcessingType.offline, file.initVector);
        // ignore: cancel_subscriptions
        final sub = await _filesApi.getFileContentsFromServer(
            file.downloadUrl, file, processingFile, false, null,
            onSuccess: (_) async {
              deleteFromProcessing(file.guid);
              final FilesCompanion filesCompanion =
                  getCompanionFromLocalFile(file, fileForOffline.path);
              await _filesDao.addFile(filesCompanion);
              onSuccess();
            },
            onError: (err) => deleteFromProcessing(file.guid));
        processingFile.subscription = sub;
        onStart(processingFile);
      }
    } else {
      await _filesDao.deleteFiles([file]);
      onSuccess();
    }
  }

  bool _isFileIsBeingProcessed(String guid) {
    try {
      return processedFiles.firstWhere((file) => file.guid == guid) != null;
    } catch (err) {
      return false;
    }
  }

  ProcessingFile addFileToProcessing(LocalFile file, File deviceLocation,
      ProcessingType type, String ivBase64) {
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
      ivBase64: ivBase64,
    );

    processedFiles.add(processingFile);
    print("process added: ${processedFiles.length}");
    return processingFile;
  }

  void deleteFromProcessing(String guid, {bool deleteLocally = false}) {
    try {
      final fileToDelete =
          processedFiles.firstWhere((file) => file.guid == guid);
      fileToDelete.endProcess();
      if (deleteLocally) fileToDelete.fileOnDevice.delete(recursive: true);
      processedFiles.removeWhere((file) => file.guid == guid);
      print("process removed: ${processedFiles.length}");
    } catch (err) {}
  }

  Future<void> clearCache({deleteCachedImages = false}) async {
    return _filesLocal.deleteFilesFromCache(
        deleteCachedImages: deleteCachedImages);
  }

  Future<void> createPublicLink({
    @required LocalFile file,
    @required Function(String) onSuccess,
    @required Function(String) onError,
  }) async {
    return onGetPublicLink(
        name: file.name,
        size: file.size,
        isFolder: false,
        path: file.path,
        onSuccess: onSuccess,
        onError: onError);
  }

  Future<void> createSecureLink({
    @required LocalFile file,
    @required Function(SecureLink) onSuccess,
    @required Function(String) onError,
    @required String password,
    @required String email,
    @required bool isKey,
  }) async {
    return onGetSecureLink(
      password: password,
      name: file.name,
      size: file.size,
      isFolder: false,
      path: file.path,
      onSuccess: onSuccess,
      onError: onError,
      email: email,
      isKey: isKey,
    );
  }

  Future<List<Recipient>> getRecipient() async {
    return _mailApi.getRecipient();
  }

  Future sendViaEmail(MailTemplate template, String to) async {
    final accounts = await _mailApi.getAccounts();
    if (accounts.isEmpty) {
      final uri = template.mailTo(to);
      if (await canLaunch(uri)) {
        await launch(uri);
      }
    } else {
      final accountID = accounts.first.accountID;
      final folders = await _mailApi.getFolder(accountID);
      final sendFolder = folders.folders.firstWhere(
          (item) => item.type == Folder.sendType,
          orElse: () => Folder(Folder.sentFolder, 2, ""));
      final sendFolderPath = folders.namespace + sendFolder.fullName;
      await _mailApi.sendMail(
          accountID, sendFolderPath, template.subject, template.body, to);
    }
  }

  Future<List<Recipient>> searchContact(String pattern) async {
    return _mailApi.searchContact(pattern);
  }

  Future<void> shareFileToContact(
      LocalFile localFile, Set<String> canEdit, Set<String> canSee) async {
    return _mailApi.shareFileToContact(localFile, canEdit, canSee);
  }
}
