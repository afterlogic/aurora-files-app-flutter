import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/dialogs_android/move_options_bottom_sheet.dart';
import 'package:aurorafiles/screens/files/dialogs_android/rename_dialog_android.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';

import 'delete_confirmation_dialog.dart';

class FileOptionsBottomSheet extends StatefulWidget {
  final File file;
  final FilesState filesState;

  const FileOptionsBottomSheet({
    Key key,
    @required this.file,
    @required this.filesState,
  }) : super(key: key);

  @override
  _FileOptionsBottomSheetState createState() => _FileOptionsBottomSheetState();
}

class _FileOptionsBottomSheetState extends State<FileOptionsBottomSheet> {
  bool _isGettingPublicLink = false;
  bool _hasPublicLink = false;

  @override
  void initState() {
    super.initState();
    _hasPublicLink = widget.file.published;
  }

  void _showErrSnack(BuildContext context, String err) {
    widget.filesState.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err), backgroundColor: Theme.of(context).errorColor));
  }

  void _getLink() {
    widget.filesState.onGetPublicLink(
      name: widget.file.name,
      size: widget.file.size,
      isFolder: widget.file.isFolder,
      onSuccess: () async {
        widget.filesState.onGetFiles(path: widget.filesState.currentPath);
        setState(() => _isGettingPublicLink = false);
        Navigator.pop(context, "Link coppied to clipboard");
      },
      onError: (String err) => setState(() {
        _isGettingPublicLink = false;
        _hasPublicLink = false;
        _showErrSnack(context, err);
      }),
    );
  }

  void _deleteLink() {
    widget.filesState.onDeletePublicLink(
      name: widget.file.name,
      onSuccess: () async {
        widget.filesState.onGetFiles(path: widget.filesState.currentPath);
        setState(() => _isGettingPublicLink = false);
      },
      onError: (String err) => setState(() {
        _isGettingPublicLink = false;
        _hasPublicLink = true;
        _showErrSnack(context, err);
      }),
    );
  }

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
              SwitchListTile.adaptive(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.link),
                  title: Text("Public link access"),
                ),
                activeColor: Theme.of(context).primaryColor,
                value: _hasPublicLink,
                onChanged: _isGettingPublicLink
                    ? null
                    : (bool val) {
                        setState(() {
                          _isGettingPublicLink = true;
                          _hasPublicLink = val;
                        });
                        if (val) {
                          _getLink();
                        } else {
                          _deleteLink();
                        }
                      },
              ),
              if (_hasPublicLink)
                ListTile(
                  leading: Icon(Icons.content_copy),
                  title: Text("Copy public link"),
                  onTap: _isGettingPublicLink
                      ? null
                      : () {
                          setState(() => _isGettingPublicLink = true);
                          _getLink();
                        },
                ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Copy/Move"),
                onTap: () {
                  Navigator.pop(context);
                  widget.filesState.enableMoveMode([widget.file]);
                  widget.filesState.scaffoldKey.currentState.showBottomSheet(
                    (_) =>
                        MoveOptionsBottomSheet(filesState: widget.filesState),
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
                    ),
                  );
                  if (result is String) {
                    widget.filesState
                        .onGetFiles(path: widget.filesState.currentPath);
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
                    widget.filesState.onDeleteFiles(
                      filesToDelete: [widget.file],
                      onSuccess: () {
                        widget.filesState
                            .onGetFiles(path: widget.filesState.currentPath);
                      },
                      onError: (String err) => _showErrSnack(context, err),
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