import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int itemsNumber;
  final bool isFolder;

  const DeleteConfirmationDialog({Key key, this.itemsNumber, this.isFolder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    String itemName;
    if (isFolder == true)
      itemName = s.folder;
    else if (isFolder == false)
      itemName = s.file;
    else
      itemName = "${s.file}/${s.folder}";

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(itemsNumber != null && itemsNumber > 1
            ? s.delete_files
            : s.delete_file),
        content: Text(
            s.confirm_delete_file(itemsNumber != null &&
                itemsNumber > 1
                ? s.these_files(itemsNumber.toString())
                : s.these_files(itemName))),
        actions: <Widget>[
          CupertinoButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoButton(
            child: Text(
              s.delete,
              style: TextStyle(color: Theme
                  .of(context)
                  .errorColor),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(itemsNumber != null && itemsNumber > 1
            ? s.delete_files
            : s.delete_file),
        content: Text(
            s.confirm_delete_file(itemsNumber != null &&
                itemsNumber > 1
                ? s.these_files(itemsNumber.toString())
                : s.these_files(itemName))),
        actions: <Widget>[
          FlatButton(
            child: Text(s.cancel.toUpperCase()),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text(
              s.delete.toUpperCase(),
              style: TextStyle(color: Theme
                  .of(context)
                  .errorColor),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    }
  }
}
