import 'dart:convert';

import 'package:aurora_ui_kit/components/dialogs/am_dialog.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/components/emails_input.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:flutter/material.dart';

class ShareToEmailDialog extends StatefulWidget {
  final FileViewerState fileViewerState;
  final LocalFile file;

  ShareToEmailDialog(this.fileViewerState, this.file);

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

  Future<List<Recipient>> searchContact(String pattern) {
    return widget.fileViewerState.searchContact(pattern.replaceAll(" ", ""));
  }

  share() async {
    canSeeKey.currentState.addEmail();
    canEditKey.currentState.addEmail();
    try {
      canEdit.forEach((element) => canSee.remove(element));
      progress = true;
      setState(() {});
      await widget.fileViewerState
          .shareFileToContact(widget.file, canEdit, canSee);
      Navigator.pop(context);
    } catch (e) {}
    progress = false;
  }

  @override
  void initState() {
    super.initState();
    initShares();
  }

  initShares() {
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
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    return AMDialog(
      title: Text(s.share),
      content: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            EmailsInput(
              searchContact,
              canSee,
              !progress,
              canSeeKey,
            ),
            SizedBox(height: 20),
            EmailsInput(
              searchContact,
              canEdit,
              !progress,
              canEditKey,
            ),
          ],
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
