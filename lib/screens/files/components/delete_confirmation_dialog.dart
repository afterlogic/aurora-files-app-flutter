import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int itemsNumber;

  const DeleteConfirmationDialog({Key key, this.itemsNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete files"),
      content: Text(
          "Are you sure you want to delete ${itemsNumber != null && itemsNumber > 1 ? "these $itemsNumber files/folders" : "this file/folder"}"),
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
