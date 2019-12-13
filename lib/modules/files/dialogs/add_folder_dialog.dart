import 'dart:io';

import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/ios/alert_input_ios.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFolderDialogAndroid extends StatefulWidget {
  final FilesState filesState;
  final FilesPageState filesPageState;

  const AddFolderDialogAndroid({
    Key key,
    @required this.filesState,
    @required this.filesPageState,
  }) : super(key: key);

  @override
  _AddFolderDialogAndroidState createState() => _AddFolderDialogAndroidState();
}

class _AddFolderDialogAndroidState extends State<AddFolderDialogAndroid> {
  final _folderNameCtrl = TextEditingController();
  final _addFolderFormKey = GlobalKey<FormState>();
  S s;
  bool isAdding = false;
  String errMsg = "";

  @override
  void dispose() {
    super.dispose();
    _folderNameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    s = S.of(context);
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(s.add_new_folder),
        content: isAdding
            ? Row(
          children: <Widget>[
            CupertinoActivityIndicator(),
            SizedBox(width: 20.0),
            Text(s.adding_folder(_folderNameCtrl.text))
          ],
        )
            : Form(
          key: _addFolderFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (errMsg is String && errMsg.length > 0)
                Text(errMsg,
                    style:
                    TextStyle(color: Theme
                        .of(context)
                        .errorColor)),
              AlertInputIos(
                controller: _folderNameCtrl,
                autofocus: true,
                placeholder: s.enter_folder_name,
              )
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoButton(
              child: Text(s.add),
              onPressed: isAdding
                  ? null
                  : () {
                if (!_addFolderFormKey.currentState.validate()) return;
                errMsg = "";
                setState(() => isAdding = true);
                widget.filesPageState.onCreateNewFolder(
                  storage: widget.filesState.selectedStorage,
                  folderName: _folderNameCtrl.text,
                  onError: (String err) {
                    errMsg = err;
                    setState(() => isAdding = false);
                  },
                  onSuccess: (String newNameFromServer) {
                    widget.filesPageState.onGetFiles();
                    Navigator.pop(context, newNameFromServer);
                  },
                );
              }),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(s.add_new_folder),
        content: isAdding
            ? Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 20.0),
            Expanded(child: Text(s.adding_folder(_folderNameCtrl.text)))
          ],
        )
            : Form(
          key: _addFolderFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (errMsg is String && errMsg.length > 0)
                Text(errMsg,
                    style:
                    TextStyle(color: Theme
                        .of(context)
                        .errorColor)),
              TextFormField(
                controller: _folderNameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: s.enter_folder_name,
                  border: UnderlineInputBorder(),
                ),
                validator: (value) =>
                    validateInput(
                      value,
                      [
                        ValidationTypes.empty,
                        ValidationTypes.fileName,
                        ValidationTypes.uniqueName,
                      ],
                      widget.filesPageState.currentFiles,
                    ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(s.cancel.toUpperCase()),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
              child: Text(s.add.toUpperCase()),
              onPressed: isAdding
                  ? null
                  : () {
                if (!_addFolderFormKey.currentState.validate()) return;
                errMsg = "";
                setState(() => isAdding = true);
                widget.filesPageState.onCreateNewFolder(
                  storage: widget.filesState.selectedStorage,
                  folderName: _folderNameCtrl.text,
                  onError: (String err) {
                    errMsg = err;
                    setState(() => isAdding = false);
                  },
                  onSuccess: (String newNameFromServer) {
                    widget.filesPageState.onGetFiles();
                    Navigator.pop(context, newNameFromServer);
                  },
                );
              }),
        ],
      );
    }
  }
}
