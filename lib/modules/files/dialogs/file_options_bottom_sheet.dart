import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/components/public_link_switch.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'delete_confirmation_dialog.dart';
import 'rename_dialog_android.dart';

class FileOptionsBottomSheet extends StatefulWidget {
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;

  const FileOptionsBottomSheet({
    Key key,
    @required this.file,
    @required this.filesState,
    @required this.filesPageState,
  }) : super(key: key);

  @override
  _FileOptionsBottomSheetState createState() => _FileOptionsBottomSheetState();
}

class _FileOptionsBottomSheetState extends State<FileOptionsBottomSheet>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.file.name,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Divider(height: 0),
        LimitedBox(
          maxHeight: 260.0,
          child: ListView(
            padding: EdgeInsets.only(top: 0.0, bottom: MediaQuery.of(context).padding.bottom),
            children: <Widget>[
              PublicLinkSwitch(
                file: widget.file,
                filesState: widget.filesState,
                filesPageState: widget.filesPageState,
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(widget.file.isFolder
                    ? MdiIcons.folderMove
                    : MdiIcons.fileMove),
                title: Text("Copy/Move"),
                onTap: () {
                  widget.filesState.updateFilesCb =
                      widget.filesPageState.onGetFiles;
                  widget.filesState.enableMoveMode(filesToMove: [widget.file]);
                  Navigator.pop(context);
                },
              ),
              if (!widget.file.isFolder)
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text("Share"),
                  onTap: () => {},
                ),
              if (!Platform.isIOS && !widget.file.isFolder)
                ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text("Download"),
                  onTap: () {},
                ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Rename"),
                onTap: () async {
                  Navigator.pop(context);
                  final result = Platform.isIOS
                      ? await showCupertinoDialog(
                          context: context,
                          builder: (_) => RenameDialog(
                                file: widget.file,
                                filesState: widget.filesState,
                                filesPageState: widget.filesPageState,
                              ))
                      : await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => RenameDialog(
                            file: widget.file,
                            filesState: widget.filesState,
                            filesPageState: widget.filesPageState,
                          ),
                        );
                  if (result is String) {
                    widget.filesPageState.onGetFiles();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text("Delete"),
                onTap: () async {
                  Navigator.pop(context);
                  bool shouldDelete;
                  if (Platform.isIOS) {
                    shouldDelete = await showCupertinoDialog(
                        context: context,
                        builder: (_) =>
                            DeleteConfirmationDialog(itemsNumber: 1));
                  } else {
                    shouldDelete = await showDialog(
                        context: context,
                        builder: (_) =>
                            DeleteConfirmationDialog(itemsNumber: 1));
                  }
                  if (shouldDelete == true) {
                    widget.filesPageState.onDeleteFiles(
                      storage: widget.filesState.selectedStorage,
                      filesToDelete: [widget.file],
                      onSuccess: () => widget.filesPageState.onGetFiles(),
                      onError: (String err) => showSnack(
                        context: context,
                        scaffoldState:
                            widget.filesPageState.scaffoldKey.currentState,
                        msg: err,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}