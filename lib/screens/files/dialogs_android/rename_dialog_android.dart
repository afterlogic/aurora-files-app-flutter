import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/state/files_page_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class RenameDialog extends StatefulWidget {
  final File file;
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

  bool isRenaming = false;
  String errMsg = "";

  // with .
  String fileExtension = "";

  @override
  void initState() {
    super.initState();
    _fileNameCtrl.text = widget.file.isFolder
        ? widget.file.name
        : _getFileNameWithoutExtension();
  }

  @override
  void dispose() {
    super.dispose();
    _fileNameCtrl.dispose();
  }

  String _getFileNameWithoutExtension() {
    final List<String> splitFileName = widget.file.name.split('.');
    fileExtension = ".${splitFileName[splitFileName.length - 1]}";

    return splitFileName.sublist(0, splitFileName.length - 1).join(".");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Rename ${widget.file.name}"),
      content: isRenaming
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Renaming to ${_fileNameCtrl.text}.$fileExtension")
              ],
            )
          : Form(
              key: _renameFormKey,
              child: TextFormField(
                controller: _fileNameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Enter new name",
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
                  fileExtension,
                ),
              ),
            ),
      actions: <Widget>[
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
            child: Text("RENAME"),
            onPressed: isRenaming
                ? null
                : () {
                    if (!_renameFormKey.currentState.validate()) return;
                    errMsg = "";
                    setState(() => isRenaming = true);
                    widget.filesState.onRename(
                      file: widget.file,
                      newName: _fileNameCtrl.text + fileExtension,
                      onError: (String err) {
                        errMsg = err;
                        setState(() => isRenaming = false);
                      },
                      onSuccess: (String newNameFromServer) {
                        widget.filesPageState.onGetFiles(
                            path: widget.file.path,
                            storage: widget.filesState.selectedStorage);
                        Navigator.pop(context, newNameFromServer);
                      },
                    );
                  }),
      ],
    );
  }
}
