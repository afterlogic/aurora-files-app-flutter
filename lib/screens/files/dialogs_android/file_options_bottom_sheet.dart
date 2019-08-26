import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/dialogs_android/rename_dialog_android.dart';
import 'package:aurorafiles/screens/files/state/files_page_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';

import 'delete_confirmation_dialog.dart';

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
  bool _isGettingPublicLink = false;
  bool _hasPublicLink = false;

  @override
  void initState() {
    super.initState();
    _hasPublicLink = widget.file.published;
  }

  void _getLink() {
    widget.filesState.onGetPublicLink(
      path: widget.filesPageState.pagePath,
      name: widget.file.name,
      size: widget.file.size,
      isFolder: widget.file.isFolder,
      onSuccess: () async {
        widget.filesPageState.onGetFiles(
            path: widget.filesPageState.pagePath,
            storage: widget.filesState.selectedStorage);
        setState(() => _isGettingPublicLink = false);
        showSnack(
          context: context,
          scaffoldState: widget.filesPageState.scaffoldKey.currentState,
          msg: "Link coppied to clipboard",
          isError: false
        );
        Navigator.pop(context);
      },
      onError: (String err) => setState(() {
        _isGettingPublicLink = false;
        _hasPublicLink = false;
        showSnack(
          context: context,
          scaffoldState: widget.filesPageState.scaffoldKey.currentState,
          msg: err,
        );
      }),
    );
  }

  void _deleteLink() {
    widget.filesState.onDeletePublicLink(
      path: widget.filesPageState.pagePath,
      name: widget.file.name,
      onSuccess: () async {
        widget.filesPageState.onGetFiles(
            path: widget.filesPageState.pagePath,
            storage: widget.filesState.selectedStorage);
        setState(() => _isGettingPublicLink = false);
      },
      onError: (String err) => setState(() {
        _isGettingPublicLink = false;
        _hasPublicLink = true;
        showSnack(
          context: context,
          scaffoldState: widget.filesPageState.scaffoldKey.currentState,
          msg: err,
        );
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
                  widget.filesState.enableMoveMode(filesToMove: [widget.file]);
//                  _scaffoldKey.currentState.showBottomSheet(
//                    (_) =>
//                        MoveOptionsBottomSheet(filesState: widget.filesState),
//                  );
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
