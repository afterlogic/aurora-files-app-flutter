import 'package:aurorafiles/screens/file_viewer/state/file_viewer_state.dart';
import 'package:aurorafiles/screens/files/dialogs/rename_dialog_android.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'components/image_viewer.dart';
import 'components/info_list_tile.dart';

class FileViewerAndroid extends StatelessWidget {
  final file;

  // this is to update files on the files screen after file renaming
  final FilesState filesState;

  FileViewerAndroid({
    Key key,
    @required this.file,
    @required this.filesState,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final FileViewerState fileViewerState = FileViewerState();
    fileViewerState.fileName = file["Name"];

    return MultiProvider(
      providers: [
        Provider(
          builder: (_) => fileViewerState,
          dispose: (_, val) => val.dispose(),
        ),
        Provider(
          builder: (_) => filesState,
          dispose: (_, val) => val.dispose(),
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              tooltip: "Move/Copy",
              onPressed: () {},
            ),
            if (file["Actions"]["download"] != null &&
                file["Actions"]["download"]["url"] != null)
              IconButton(
                icon: Icon(Icons.file_download),
                tooltip: "Download",
                onPressed: () => filesState.onDownloadFile(
                  url: file["Actions"]["download"]["url"],
                  fileName: file["Name"],
                  onStart: () =>
                      _showInfoSnack(context, "Downloading ${file["Name"]}"),
                  onSuccess: () => _showInfoSnack(
                      context, "${file["Name"]} downloaded successfully"),
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
                    file: file,
                    filesState: filesState,
                  ),
                );
                if (result is String) {
                  file["Name"] = result;
                  fileViewerState.fileName = result;
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
            if (file["ContentType"].startsWith("image"))
              ImageViewer(file: file),
            SizedBox(height: 30.0),
            Observer(
                builder: (_) => InfoListTile(
                    label: "Filename", content: fileViewerState.fileName)),
            InfoListTile(label: "Size", content: filesize(file["Size"])),
            InfoListTile(
              label: "Created",
              content: DateFormatting.formatDateFromSeconds(
                timestamp: file["LastModified"],
              ),
            ),
            InfoListTile(label: "Owner", content: file["Owner"]),
            InfoListTile(label: "Public link", content: "WIP"),
          ],
        ),
      ),
    );
  }
}
