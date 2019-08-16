import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/dialogs_android/rename_dialog_android.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/image_viewer.dart';
import 'components/info_list_tile.dart';

class FileViewerAndroid extends StatefulWidget {
  final File file;

  // this is to update files on the files screen after file renaming
  final FilesState filesState;

  FileViewerAndroid({
    Key key,
    @required this.file,
    @required this.filesState,
  }) : super(key: key);

  @override
  _FileViewerAndroidState createState() => _FileViewerAndroidState();
}

class _FileViewerAndroidState extends State<FileViewerAndroid> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File file;

  @override
  void initState() {
    super.initState();
    file = widget.file;
  }

  void _showErrSnack(BuildContext context, String msg) {
    final snack = SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).errorColor,
    );

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  void _showInfoSnack(BuildContext context, String msg) {
    final snack = SnackBar(
      content: Text(msg),
    );

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => widget.filesState,
      dispose: (_, val) => val.dispose(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              tooltip: "Move/Copy",
              onPressed: () {},
            ),
            if (widget.file.downloadUrl != null)
              IconButton(
                icon: Icon(Icons.file_download),
                tooltip: "Download",
                onPressed: () => widget.filesState.onDownloadFile(
                  url: widget.file.downloadUrl,
                  fileName: widget.file.name,
                  onStart: () => _showInfoSnack(
                      context, "Downloading ${widget.file.name}"),
                  onSuccess: () => _showInfoSnack(
                      context, "${widget.file.name} downloaded successfully"),
                  onError: (err) => _showErrSnack(context, err.toString()),
                ),
              ),
            IconButton(
              icon: Icon(Icons.link),
              tooltip: "Get public link",
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: "Rename",
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => RenameDialog(
                    file: widget.file,
                    filesState: widget.filesState,
                  ),
                );
                if (result is String) {
                  widget.filesState.currentFiles.forEach((updatedFile) {
                    if (updatedFile.id == result) {
                      setState(() => file = updatedFile);
                    }
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline),
              tooltip: "Delete file",
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            if (widget.file.contentType.startsWith("image"))
              ImageViewer(file: widget.file),
            SizedBox(height: 30.0),
            InfoListTile(label: "Filename", content: file.name),
            InfoListTile(label: "Size", content: filesize(widget.file.size)),
            InfoListTile(
              label: "Created",
              content: DateFormatting.formatDateFromSeconds(
                timestamp: widget.file.lastModified,
              ),
            ),
            InfoListTile(label: "Owner", content: widget.file.owner),
            InfoListTile(label: "Public link", content: "WIP"),
          ],
        ),
      ),
    );
  }
}
