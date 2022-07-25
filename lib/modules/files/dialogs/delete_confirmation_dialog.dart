import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
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
    if (isFolder == true) {
      itemName = s.folder;
    } else if (isFolder == false) {
      itemName = s.file;
    } else {
      itemName = "${s.file}/${s.folder}";
    }
    String title;
    if (itemsNumber != null && itemsNumber > 1) {
      title = s.delete_files;
    } else if (isFolder) {
      title = s.label_delete_folder;
    } else {
      title = s.delete_file;
    }

    return AMDialog(
      title: Text(title),
      content: Text(
        s.confirm_delete_file(
          itemsNumber != null && itemsNumber > 1
              ? s.these_files(itemsNumber.toString())
              : s.these_files(itemsNumber.toString()),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text(s.delete),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
