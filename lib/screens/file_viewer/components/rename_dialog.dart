import 'package:aurorafiles/screens/file_viewer/state/file_viewer_state.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class RenameDialog extends StatefulWidget {
  final file;
  final FileViewerState fileViewerState;
  final Function({String path}) onUpdateFilesList;

  const RenameDialog({
    Key key,
    @required this.file,
    @required this.fileViewerState,
    @required this.onUpdateFilesList,
  }) : super(key: key);

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  final fileNameCtrl = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();

  bool isRenaming = false;
  String errMsg = "";

  // without .
  String fileExtension;

  @override
  void initState() {
    final List<String> splitFileName = widget.file["Name"].split('.');
    fileExtension = splitFileName[splitFileName.length - 1];

    fileNameCtrl.text =
        splitFileName.sublist(0, splitFileName.length - 1).join(".");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Rename ${widget.file["Name"]}"),
      content: isRenaming
          ? Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Renaming to ${fileNameCtrl.text}.$fileExtension")
              ],
            )
          : Form(
              key: _renameFormKey,
              child: TextFormField(
                controller: fileNameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Enter new name",
                  border: UnderlineInputBorder(),
                ),
                validator: (value) =>
                    validateInput(value, [ValidationTypes.empty]),
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
                    widget.fileViewerState.onRename(
                      type: widget.file["Type"],
                      path: widget.file["Path"],
                      name: widget.file["Name"],
                      newName: "${fileNameCtrl.text}.$fileExtension",
                      isFolder: widget.file["IsFolder"],
                      isLink: widget.file["IsLink"],
                      onError: (String err) {
                        errMsg = err;
                        setState(() => isRenaming = false);
                      },
                      onSuccess: (String newNameFromServer) {
                        Navigator.pop(context, newNameFromServer);
                        widget.onUpdateFilesList(path: widget.file["Path"]);
                      },
                    );
                  }),
      ],
    );
  }
}
