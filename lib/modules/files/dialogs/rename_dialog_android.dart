import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class RenameDialog extends StatefulWidget {
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;

  const RenameDialog({
    Key? key,
    required this.file,
    required this.filesPageState,
    required this.filesState,
  }) : super(key: key);

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  final _fileNameCtrl = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();
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
    final s = context.l10n;
    return AMDialog(
      title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text("${s.rename} ${widget.file.name}")),
      content: Container(
        child: isRenaming
            ? Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(child: Text(s.renaming_to(_fileNameCtrl.text))),
                ],
              )
            : Form(
                key: _renameFormKey,
                child: TextFormField(
                  controller: _fileNameCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    errorText: errMsg.isEmpty == true ? null : errMsg,
                    hintText: s.enter_new_name,
                    border: const UnderlineInputBorder(),
                  ),
                  validator: (value) => validateInput(
                    value: value ?? '',
                    types: [
                      ValidationTypes.empty,
                      ValidationTypes.uniqueName,
                      ValidationTypes.fileName,
                    ],
                    otherItems: FileUtils.getFilesFromFolder(
                      widget.filesPageState.currentFiles,
                      widget.file.path,
                    ),
                    isFolder: widget.file.isFolder,
                  ),
                ),
              ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
            onPressed: isRenaming
                ? null
                : () {
                    if (_renameFormKey.currentState?.validate() != true) return;
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
                        await widget.filesPageState.onGetFiles(
                          path: widget.file.path,
                          afterRename: true,
                        );
                        if (!mounted) return;
                        Navigator.pop(context, newNameFromServer);
                      },
                    );
                  },
            child: Text(s.rename)),
      ],
    );
  }
}
