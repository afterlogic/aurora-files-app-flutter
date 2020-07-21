import 'dart:convert';
import 'dart:io';

import 'package:aurora_ui_kit/components/dialogs/am_dialog.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/components/emails_input.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_api.dart';
import 'package:flutter/material.dart';

class ShareToEmailDialog extends StatefulWidget {
  final BuildContext context;
  final FilesState fileState;
  final LocalFile file;

  ShareToEmailDialog(
    this.fileState,
    this.file,
    this.context,
  );

  @override
  _ShareToEmailDialogState createState() => _ShareToEmailDialogState();
}

class _ShareToEmailDialogState extends State<ShareToEmailDialog> {
  S s;
  Set<String> canSee = {};
  Set<String> canEdit = {};
  bool progress = false;
  final btnFocus = FocusNode();
  final canSeeKey = GlobalKey<EmailsInputState>();
  final canEditKey = GlobalKey<EmailsInputState>();
  final PgpKeyDao _pgpKeyDao = DI.get();
  final _pgpKeyApi = PgpKeyApi();
  final Set<LocalPgpKey> pgpKeys = {};
  Set<String> pgpKeysEmail = {};
  String error;

  Future<List<Recipient>> searchContact(String pattern) {
    return widget.fileState.searchContact(pattern.replaceAll(" ", ""));
  }

  share() async {
    error = null;
    canSeeKey.currentState.addEmail();
    canEditKey.currentState.addEmail();
    canEdit.forEach((element) => canSee.remove(element));
    final addedPgpKey = <String>[];
    if (widget.file.encryptedDecryptionKey != null) {
      for (var email in [...canSee, ...canEdit]) {
        final key = pgpKeys.firstWhere((element) => element.email == email,
            orElse: () => null);
        if (key != null) {
          addedPgpKey.add(key.key);
        } else {
          error = s.error_pgp_required_key(email);
          setState(() {});
          return;
        }
      }
    }
    progress = true;
    setState(() {});
    try {
      if (addedPgpKey.isNotEmpty)
        await widget.fileState
            .addDecryptedKey(context, widget.file, addedPgpKey);
      await widget.fileState.shareFileToContact(widget.file, canEdit, canSee);
      Navigator.pop(context);
    } catch (e) {
      error = e.toString();
    }

    progress = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initShares();
  }

  initShares() async {
    if (widget.file.extendedProps == null) return;
    final map = json.decode(widget.file.extendedProps);
    if (map["Shares"] != null) {
      final shares = map["Shares"] as List;
      for (var value in shares) {
        if (value["Access"] == 2) {
          canSee.add(value["PublicId"]);
        } else if (value["Access"] == 1) {
          canEdit.add(value["PublicId"]);
        }
      }
    }
    if (widget.file.encryptedDecryptionKey != null) {
      pgpKeys.addAll(await _pgpKeyApi.getKeyFromContacts());
      pgpKeys.addAll(await _pgpKeyDao.getPublicKeys());
      pgpKeysEmail = pgpKeys.map((e) => e.email).toSet();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    return AMDialog(
      title: Text(s.btn_share_to_email),
      content: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EmailsInput(
                searchContact,
                canSee,
                !progress,
                canSeeKey,
                pgpKeysEmail,
                s.input_who_cas_see,
              ),
              SizedBox(height: 20),
              EmailsInput(
                searchContact,
                canEdit,
                !progress,
                canEditKey,
                pgpKeysEmail,
                s.input_who_cas_edit,
              ),
              if (widget.file.isFolder) SizedBox(height: 20),
              if (widget.file.isFolder)
                Text(
                  s.hint_share_folder,
                ),
              if (error != null) SizedBox(height: 20),
              if (error != null)
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
          focusNode: btnFocus,
          child: Text(s.btn_share_save),
          onPressed: progress ? null : share,
        ),
        FlatButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
