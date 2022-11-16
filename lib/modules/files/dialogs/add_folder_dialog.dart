import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

class AddFolderDialogAndroid extends StatefulWidget {
  final FilesState filesState;
  final FilesPageState filesPageState;

  const AddFolderDialogAndroid({
    Key? key,
    required this.filesState,
    required this.filesPageState,
  }) : super(key: key);

  @override
  _AddFolderDialogAndroidState createState() => _AddFolderDialogAndroidState();
}

class _AddFolderDialogAndroidState extends State<AddFolderDialogAndroid> {
  final _folderNameCtrl = TextEditingController();
  final _addFolderFormKey = GlobalKey<FormState>();
  bool isAdding = false;
  String errMsg = "";

  @override
  void dispose() {
    super.dispose();
    _folderNameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AMDialog(
      title: Text(s.add_new_folder),
      content: isAdding
          ? Row(
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(width: 20.0),
                Expanded(child: Text(s.adding_folder(_folderNameCtrl.text)))
              ],
            )
          : Form(
              key: _addFolderFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (errMsg.isNotEmpty)
                    Text(
                      errMsg,
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  TextFormField(
                    controller: _folderNameCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: s.enter_folder_name,
                      border: const UnderlineInputBorder(),
                    ),
                    validator: (value) => validateInput(
                      value ?? '',
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
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
            onPressed: isAdding
                ? null
                : () {
                    if (_addFolderFormKey.currentState?.validate() == false) {
                      return;
                    }
                    errMsg = "";
                    setState(() => isAdding = true);
                    widget.filesPageState.onCreateNewFolder(
                      storage: widget.filesState.selectedStorage,
                      folderName: _folderNameCtrl.text,
                      onError: (String err) {
                        errMsg = err;
                        setState(() => isAdding = false);
                      },
                      onSuccess: () {
                        widget.filesPageState.onGetFiles();
                        Navigator.pop(context);
                      },
                    );
                  },
            child: Text(s.add)),
      ],
    );
  }
}
