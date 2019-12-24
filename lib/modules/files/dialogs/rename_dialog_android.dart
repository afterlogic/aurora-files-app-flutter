import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/i18n.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/ios/alert_input_ios.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RenameDialog extends StatefulWidget {
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;

  const RenameDialog({
    Key key,
    @required this.file,
    @required this.filesPageState,
    @required this.filesState,
  }) : super(key: key);

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  final _fileNameCtrl = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();
  S s;
  bool isRenaming = false;
  String errMsg = "";

  @override
  void initState() {
    super.initState();

    _fileNameCtrl.text = widget.file.name;
    if (!widget.file.isFolder) _setCursorPositionBeforeExtension();
  }

  _setCursorPositionBeforeExtension() {
    final List<String> splitFileName = widget.file.name.split('.');
    final fileExtension = ".${splitFileName[splitFileName.length - 1]}";
    _fileNameCtrl.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _fileNameCtrl.text.length - fileExtension.length,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fileNameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    s = S.of(context);
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text("${s.rename} ${widget.file.name}"),
        content: isRenaming
            ? Row(
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  SizedBox(width: 20.0),
                  Text(s.renaming_to(_fileNameCtrl.text))
                ],
              )
            : Form(
                key: _renameFormKey,
                child: AlertInputIos(
                  controller: _fileNameCtrl,
                  autofocus: true,
                  placeholder: s.enter_new_name,
                ),
              ),
        actions: <Widget>[
          CupertinoButton(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoButton(
              child: Text(s.rename),
              onPressed: isRenaming
                  ? null
                  : () {
                      if (!_renameFormKey.currentState.validate()) return;
                      errMsg = "";
                      setState(() => isRenaming = true);
                      widget.filesState.onRename(
                        file: widget.file,
                        newName: _fileNameCtrl.text,
                        onError: (String err) {
                          errMsg = err;
                          setState(() => isRenaming = false);
                        },
                        onSuccess: (String newNameFromServer) async {
                          await widget.filesPageState
                              .onGetFiles(path: widget.file.path);
                          Navigator.pop(context, newNameFromServer);
                        },
                      );
                    }),
        ],
      );
    } else {
      return AlertDialog(
        title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text("${s.rename} ${widget.file.name}")),
        content: Container(
          child: isRenaming
              ? Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(child: Text(s.renaming_to(_fileNameCtrl.text))),
                  ],
                )
              : Form(
                  key: _renameFormKey,
                  child: TextFormField(
                    controller: _fileNameCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      errorText: errMsg?.isEmpty == true ? null : errMsg,
                      hintText: s.enter_new_name,
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value,
                      [
                        ValidationTypes.empty,
                        ValidationTypes.uniqueName,
                        ValidationTypes.fileName,
                      ],
                      widget.filesPageState.currentFiles,
                    ),
                  ),
                ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(s.cancel.toUpperCase()),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
              child: Text(s.rename.toUpperCase()),
              onPressed: isRenaming
                  ? null
                  : () {
                      if (!_renameFormKey.currentState.validate()) return;
                      errMsg = "";
                      setState(() => isRenaming = true);
                      widget.filesState.onRename(
                        file: widget.file,
                        newName: _fileNameCtrl.text,
                        onError: (String err) {
                          errMsg = err;
                          setState(() => isRenaming = false);
                        },
                        onSuccess: (String newNameFromServer) async {
                          await widget.filesPageState
                              .onGetFiles(path: widget.file.path);
                          Navigator.pop(context, newNameFromServer);
                        },
                      );
                    }),
        ],
      );
    }
  }
}
