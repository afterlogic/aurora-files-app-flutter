import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/models/contact_suggestion.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/dialogs/key_request_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_api.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/repository/mail_api.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/utils/custom_exception.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:crypto_stream/algorithm/aes.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefixEncrypt;
import 'package:file/memory.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'file_viewer_state.g.dart';

class FileViewerState = _FileViewerState with _$FileViewerState;

abstract class _FileViewerState with Store {
  final _filesApi = new FilesApi();
  final _mailApi = new MailApi();
  final _filesLocal = new FilesLocalStorage();
  FilesState fileState;
  Aes aes = DI.get();
  Storage storage;
  LocalFile file;

  @observable
  double downloadProgress;
  @observable
  File fileWithContents;

  ProcessingFile processingFile;

  Future<Uint8List> decryptOfflineFile(String password) async {
    IV iv = IV.fromBase16(file.initVector);
    String decryptKey;
    if (file.encryptedDecryptionKey != null) {
      decryptKey = await PgpKeyUtil.instance.userDecrypt(
          file.type == "shared"
              ? jsonDecode(file.extendedProps)["ParanoidKeyShared"]
              : file.encryptedDecryptionKey,
          password);
    } else {
      decryptKey = AppStore.settingsState.currentKey;
    }
    final key = prefixEncrypt.Key.fromBase16(decryptKey);
    final decrypted = await aes.decrypt(
      await fileWithContents.readAsBytes(),
      key.base64,
      iv.base64,
      true,
    );
    return Uint8List.fromList(decrypted);
  }

  Future<void> _getPreviewFile(
      String _password, File fileToView, BuildContext context,
      {Function(File) onDownloadEnd, Function(String) onError}) async {
    String password = _password;
    if (file.encryptedDecryptionKey != null) {
      if (password == null) {
        password = await KeyRequestDialog.request(context);
        if (password == null) {
          throw "Password is null";
        }
      }
    }
    downloadProgress = 0.0;
    await Future.delayed(Duration(milliseconds: 100));
    // get file contents
    if (AppStore.filesState.isOfflineMode) {
      fileWithContents = new File(file.localPath);
      downloadProgress = null;
      if (onDownloadEnd != null) onDownloadEnd(fileWithContents);
    } else {
      if (await fileToView.length() > 0) {
        fileWithContents = fileToView;

        downloadProgress = null;
        if (onDownloadEnd != null) onDownloadEnd(fileToView);
      } else {
        // view file are not added to the processingFiles list as of now
        processingFile = new ProcessingFile(
          guid: file.guid,
          name: file.name,
          size: file.size,
          fileOnDevice: fileToView,
          processingType: getFileType(file) == FileType.image
              ? ProcessingType.cacheImage
              : ProcessingType.cacheToDelete,
        );
        // ignore: cancel_subscriptions
        final sub = await _filesApi.getFileContentsFromServer(
          file.viewUrl,
          file,
          processingFile,
          file.initVector != null,
          password,
          onSuccess: (_) {
            fileWithContents = fileToView;
            downloadProgress = null;
            processingFile = null;
            if (onDownloadEnd != null) onDownloadEnd(fileToView);
          },
          updateViewerProgress: (progress) => downloadProgress = progress,
          onError: (err) {
            processingFile = null;
            onError(err);
          },
        );
        processingFile.subscription = sub;
      }
    }
    // if encrypted - decrypt
//    if (file.initVector != null) {
//      downloadProgress = 0.5;
//      await _filesLocal.decryptFile(
//        file: file,
//        fileBytes: fileContent,
//        updateDecryptionProgress: (progress) =>
//            downloadProgress = progress / 2 + 0.5, getChunk: (List a) {},
//      );
//    } else {
//      fileBytes = fileContent;
//    }
  }

  Future<void> getPreviewImage(
    String password,
    Function(String) onError,
    BuildContext context,
  ) async {
    downloadProgress = 0.0;
    // try to retrieve the file from cache
    // if no cache, get file

    try {
      final File imageToView = file.initVector != null
          ? await MemoryFileSystem().file(file.name).create()
          : await _filesLocal.createImageCacheFile(file);
      await _getPreviewFile(
        password,
        imageToView,
        context,
        onError: (e) {
          onError(e);
        },
      );
    } catch (err) {
      onError(err is CustomException ? "Invalid password" : err.toString());
    }
  }

  Future<void> getPreviewText(
      String password, Function(String) getText, BuildContext context) async {
    downloadProgress = 0.0;
    final File textToView = await _filesLocal.createTempFile(file);
    await _getPreviewFile(password, textToView, context,
        onDownloadEnd: (File storedFile) async {
      String previewText = await fileWithContents.readAsString();
      getText(previewText);
    });
  }

  Future<void> onOpenPdf(BuildContext context) async {
    final File pdfToView =
        await _filesLocal.createTempFile(file, useName: true);
    await _getPreviewFile(null, pdfToView, context,
        onDownloadEnd: (File storedFile) {
      fileWithContents = storedFile;
      _filesLocal.openFileWith(fileWithContents);
    });
  }

  Future<void> uploadSecureFile(BuildContext context,
      {@required File file,
      @required Function(ProcessingFile) onUploadStart,
      @required Function() onSuccess,
      @required Function(String) onError,
      @required bool passwordEncryption,
      @required String encryptionRecipientEmail,
      @required String extend}) {
    return fileState.uploadFile(context,
        passwordEncryption: passwordEncryption,
        encryptionRecipientEmail: encryptionRecipientEmail,
        name: this.file.name + extend,
        shouldEncrypt: false,
        file: file,
        path: this.file.path,
        onUploadStart: onUploadStart,
        onSuccess: onSuccess,
        onError: onError);
  }

  Future<ContactSuggestion> searchContact(String pattern) async {
    return _mailApi.searchContact(pattern);
  }

  Future<void> shareFileToContact(
      LocalFile localFile, Set<String> canEdit, Set<String> canSee) async {
    return _mailApi.shareFileToContact(localFile, canEdit, canSee);
  }
}
