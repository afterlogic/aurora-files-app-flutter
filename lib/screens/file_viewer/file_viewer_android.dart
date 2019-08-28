import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/components/public_link_switch.dart';
import 'package:aurorafiles/screens/files/dialogs_android/rename_dialog_android.dart';
import 'package:aurorafiles/screens/files/state/files_page_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'components/image_viewer.dart';
import 'components/info_list_tile.dart';

class FileViewerAndroid extends StatefulWidget {
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;

  FileViewerAndroid({
    Key key,
    @required this.file,
    @required this.filesState,
    @required this.filesPageState,
  }) : super(key: key);

  @override
  _FileViewerAndroidState createState() => _FileViewerAndroidState();
}

class _FileViewerAndroidState extends State<FileViewerAndroid> {
  final GlobalKey<ScaffoldState> _fileViewerScaffoldKey =
      GlobalKey<ScaffoldState>();

  LocalFile file;

  @override
  void initState() {
    super.initState();
    file = widget.file;
  }

  void _updateFile(String fileId) {
    widget.filesPageState.currentFiles.forEach((updatedFile) {
      if (updatedFile.id == fileId) {
        setState(() => file = updatedFile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FilesState>(
          builder: (_) => widget.filesState,
          dispose: (_, value) => value.dispose(),
        ),
        Provider<FilesPageState>(
          builder: (_) => widget.filesPageState,
          dispose: (_, value) => value.dispose(),
        ),
      ],
      child: Scaffold(
        key: _fileViewerScaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.fileMove),
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
                  onStart: () => showSnack(
                    context: context,
                    scaffoldState: _fileViewerScaffoldKey.currentState,
                    msg: "Downloading ${widget.file.name}",
                    isError: false,
                  ),
                  onSuccess: () => showSnack(
                    context: context,
                    scaffoldState: _fileViewerScaffoldKey.currentState,
                    msg: "${widget.file.name} downloaded successfully",
                    isError: false,
                  ),
                  onError: (String err) => showSnack(
                    context: context,
                    scaffoldState: _fileViewerScaffoldKey.currentState,
                    msg: err,
                  ),
                ),
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
                    filesPageState: widget.filesPageState,
                  ),
                );
                if (result is String) _updateFile(result);
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
            InfoListTile(
              label: "Filename",
              content: file.name,
              isPublic: file.published,
              isOffline: file.localId != null,
              isEncrypted: file.initVector != null,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InfoListTile(
                      label: "Size", content: filesize(widget.file.size)),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: InfoListTile(
                    label: "Created",
                    content: DateFormatting.formatDateFromSeconds(
                      timestamp: widget.file.lastModified,
                    ),
                  ),
                ),
              ],
            ),
            InfoListTile(label: "Owner", content: widget.file.owner),
            PublicLinkSwitch(
              file: widget.file,
              isFileViewer: true,
              updateFile: _updateFile,
              scaffoldKey: _fileViewerScaffoldKey,
            ),
          ],
        ),
      ),
    );
  }
}
