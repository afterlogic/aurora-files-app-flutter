import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/string/s.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:crypto_plugin/algorithm/pgp.dart';
import 'package:flutter/cupertino.dart';
import 'package:secure_sharing/secure_sharing.dart';

import 'dialog/encrypted_share_link.dart';
import 'dialog/link_option.dart';
import 'dialog/select_encrypt_method.dart';
import 'dialog/select_recipient.dart';
import 'dialog/share_link.dart';

class SecureSharingImpl extends SecureSharing {
  Future sharing(
    BuildContext context,
    FilesState filesState,
    FileViewerState fileViewerState,
    LocalPgpKey userPrivateKey,
    LocalPgpKey userPublicKey,
    PgpKeyUtil pgpKeyUtil,
    PreparedForShare preparedForShare,
    S s,
  ) async {
    bool usePassword = true;

    if (!preparedForShare.localFile.published) {
      usePassword = await AMDialog.show(
        context: context,
        builder: (context) => LinkOptionWidget(),
      );
    }

    RecipientWithKey selectRecipientResult;
    if (usePassword != null) {
      while (true) {
        final needRecipient = await AMDialog.show(
          context: context,
          builder: (context) => ShareLink(
            userPrivateKey,
            userPublicKey,
            usePassword,
            preparedForShare,
            selectRecipientResult,
            filesState,
            fileViewerState,
            pgpKeyUtil,
          ),
        );

        if (needRecipient == null) {
          break;
        }

        selectRecipientResult = await AMDialog.show(
          context: context,
          builder: (context) => SelectRecipient(fileViewerState, s.send_public_link_to),
        );
        if (selectRecipientResult == null) {
          break;
        }
      }
    }
  }

  Future encryptSharing(
    BuildContext context,
    FilesState filesState,
    FileViewerState fileViewerState,
    LocalPgpKey userPrivateKey,
    LocalPgpKey userPublicKey,
    PgpKeyUtil pgpKeyUtil,
    PreparedForShare preparedForShare,
    Function onUpdate,
    Pgp pgp,
    S s,
  ) async {
    final selectRecipientResult = await AMDialog.show(
      context: context,
      builder: (context) => SelectRecipient(fileViewerState, s.secure_sharing),
    );

    if (selectRecipientResult is RecipientWithKey) {
      final selectEncryptMethodResult = await AMDialog.show(
        context: context,
        builder: (context) => SelectEncryptMethod(
          userPrivateKey,
          selectRecipientResult.recipient,
          selectRecipientResult.pgpKey,
          pgpKeyUtil,
        ),
      );
      if (selectEncryptMethodResult is SelectEncryptMethodResult) {
        await AMDialog.show(
          context: context,
          builder: (context) => EncryptedShareLink(
            fileViewerState,
            userPrivateKey,
            userPublicKey,
            preparedForShare,
            selectRecipientResult.recipient,
            selectRecipientResult.pgpKey,
            selectEncryptMethodResult.useKey,
            selectEncryptMethodResult.useSign,
            selectEncryptMethodResult.password,
            pgp,
            onUpdate,
            true,
            filesState,
          ),
        );
      }
    }
  }
}
