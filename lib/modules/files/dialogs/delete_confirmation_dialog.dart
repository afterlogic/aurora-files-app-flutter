import 'dart:io';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int itemsNumber;
  final bool isFolder;

  const DeleteConfirmationDialog({Key key, this.itemsNumber, this.isFolder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    String itemName;
    if (isFolder == true)
      itemName = s.folder;
    else if (isFolder == false)
      itemName = s.file;
    else
      itemName = "${s.file}/${s.folder}";

    return AMDialog(
      title: Text(itemsNumber != null && itemsNumber > 1
          ? s.delete_files
          : s.delete_file),
      content: Text(s.confirm_delete_file(itemsNumber != null && itemsNumber > 1
          ? s.these_files(itemsNumber.toString())
          : s.these_files(itemName))),
      actions: <Widget>[
        FlatButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context, false),
        ),
        FlatButton(
          child: Text(s.delete),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
