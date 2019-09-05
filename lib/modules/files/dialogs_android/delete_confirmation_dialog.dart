import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int itemsNumber;
  final bool isFolder;

  const DeleteConfirmationDialog({Key key, this.itemsNumber, this.isFolder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String itemName;
    if (isFolder == true)
      itemName = "folder";
    else if (isFolder == false)
      itemName = "file";
    else
      itemName = "file/folder";

    return AlertDialog(
      title: Text(itemsNumber != null && itemsNumber > 1
          ? "Delete files"
          : "Delete file"),
      content: Text(
          "Are you sure you want to delete ${itemsNumber != null && itemsNumber > 1 ? "these $itemsNumber files/folders" : "this $itemName?"}"),
      actions: <Widget>[
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.pop(context, false),
        ),
        FlatButton(
          child: Text(
            "DELETE",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
