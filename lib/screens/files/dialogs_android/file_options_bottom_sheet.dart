import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/components/public_link_switch.dart';
import 'package:aurorafiles/screens/files/dialogs_android/rename_dialog_android.dart';
import 'package:aurorafiles/screens/files/state/files_page_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'delete_confirmation_dialog.dart';
import 'move_options_bottom_sheet.dart';

class FileOptionsBottomSheet extends StatefulWidget {
  final File file;
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
                  Navigator.pop(context);
                  widget.filesState.enableMoveMode(filesToMove: [widget.file]);
                  widget.filesPageState.scaffoldKey.currentState
                      .showBottomSheet(
                    (_) => MoveOptionsBottomSheet(
                      filesState: widget.filesState,
                      filesPageState: widget.filesPageState,
                    ),
                  );
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
                  final result = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => RenameDialog(
                      file: widget.file,
                      filesState: widget.filesState,
                      filesPageState: widget.filesPageState,
                    ),
                  );
                  if (result is String) {
                    widget.filesPageState.onGetFiles(
                        path: widget.filesPageState.pagePath,
                        storage: widget.filesState.selectedStorage);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text("Delete"),
                onTap: () async {
                  Navigator.pop(context);
                  final bool shouldDelete = await showDialog(
                      context: context,
                      builder: (_) => DeleteConfirmationDialog(itemsNumber: 1));
                  if (shouldDelete != null && shouldDelete) {
                    widget.filesPageState.onDeleteFiles(
                      storage: widget.filesState.selectedStorage,
                      filesToDelete: [widget.file],
                      onSuccess: () {
                        widget.filesPageState.onGetFiles(
                          path: widget.filesPageState.pagePath,
                          storage: widget.filesState.selectedStorage,
                        );
                      },
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
