import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/components/public_link_switch.dart';
import 'package:aurorafiles/modules/files/dialogs/delete_confirmation_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/rename_dialog_android.dart';
import 'package:aurorafiles/modules/files/dialogs/share_dialog.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/components/pdf_viewer.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'components/image_viewer.dart';
import 'components/info_list_tile.dart';
import 'components/text_viewer.dart';

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

  final _fileViewerState = FileViewerState();

  LocalFile file;

  @override
  void initState() {
    super.initState();
    file = widget.file;
    _fileViewerState.file = widget.file;
    print("VO: file.type: ${file.contentType}");
  }

  @override
  void dispose() {
    super.dispose();
    _fileViewerState.dispose();
  }

  void _updateFile(String fileId) {
    widget.filesPageState.currentFiles.forEach((updatedFile) {
      if (updatedFile.id == fileId) {
        setState(() => file = updatedFile);
      }
    });
  }

  void _moveFile() {
    widget.filesState.updateFilesCb = widget.filesPageState.onGetFiles;
    widget.filesState.enableMoveMode(filesToMove: [file]);
    Navigator.pop(context);
  }

  void _shareFile() {
    if (_fileViewerState.fileBytes != null) {
      widget.filesState
          .onShareFile(widget.file, fileBytes: _fileViewerState.fileBytes);
    } else {
      showSnack(
        context: context,
        scaffoldState: _fileViewerScaffoldKey.currentState,
        msg: "Please wait until the file finishes loading",
        isError: false,
      );
    }
  }

  void _renameFile() async {
    final result = Platform.isIOS
        ? await showCupertinoDialog(
            context: context,
            builder: (_) => RenameDialog(
              file: file,
              filesState: widget.filesState,
              filesPageState: widget.filesPageState,
            ),
          )
        : await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => RenameDialog(
              file: file,
              filesState: widget.filesState,
              filesPageState: widget.filesPageState,
            ),
          );
    if (result is String) _updateFile(result);
  }

  void _deleteFile() async {
    bool shouldDelete;
    if (Platform.isIOS) {
      shouldDelete = await showCupertinoDialog(
          context: context,
          builder: (_) => DeleteConfirmationDialog(
                itemsNumber: 1,
                isFolder: false,
              ));
    } else {
      shouldDelete = await showDialog(
          context: context,
          builder: (_) => DeleteConfirmationDialog(
                itemsNumber: 1,
                isFolder: false,
              ));
    }
    if (shouldDelete != null && shouldDelete) {
      widget.filesPageState.onDeleteFiles(
        filesToDelete: [file],
        storage: widget.filesState.selectedStorage,
        onSuccess: () {
          widget.filesPageState.onGetFiles();
        },
        onError: (String err) {
          widget.filesPageState.filesLoading = FilesLoadingType.none;
          showSnack(
            context: context,
            scaffoldState: _fileViewerScaffoldKey.currentState,
            msg: err,
          );
        },
      );
      widget.filesPageState.filesLoading = FilesLoadingType.filesVisible;
      Navigator.pop(context);
    }
  }

  void _downloadFile() {
    widget.filesState.onDownloadFile(
      url: file.downloadUrl,
      fileName: file.name,
      onStart: () => showSnack(
        context: context,
        scaffoldState: _fileViewerScaffoldKey.currentState,
        msg: "Downloading ${file.name}",
        isError: false,
      ),
      onSuccess: (String path) => showSnack(
          context: context,
          scaffoldState: _fileViewerScaffoldKey.currentState,
          msg: "${file.name} downloaded successfully into: $path",
          isError: false,
          duration: Duration(minutes: 10),
          action: SnackBarAction(
            label: "OK",
            onPressed: _fileViewerScaffoldKey.currentState.hideCurrentSnackBar,
          )),
      onError: (String err) => showSnack(
        context: context,
        scaffoldState: _fileViewerScaffoldKey.currentState,
        msg: err,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FilesState>(
          builder: (_) => widget.filesState,
        ),
        Provider<FilesPageState>(
          builder: (_) => widget.filesPageState,
        ),
        Provider<AuthState>(
          builder: (_) => AppStore.authState,
        ),
      ],
      child: Scaffold(
        key: _fileViewerScaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.fileMove),
              tooltip: "Move/Copy",
              onPressed: _moveFile,
            ),
            IconButton(
              icon: Icon(Platform.isIOS ? MdiIcons.exportVariant : Icons.share),
              tooltip: "Share",
              onPressed: _shareFile,
            ),
            if (file.downloadUrl != null && !Platform.isIOS)
              IconButton(
                icon: Icon(Icons.file_download),
                tooltip: "Download",
                onPressed: _downloadFile,
              ),
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: "Rename",
              onPressed: _renameFile,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline),
              tooltip: "Delete file",
              onPressed: _deleteFile,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            if (file.contentType.startsWith("image"))
              ImageViewer(
                fileViewerState: _fileViewerState,
                scaffoldState: _fileViewerScaffoldKey.currentState,
              ),
            if (file.contentType == "text/plain" ||
                file.contentType == "application/json")
              TextViewer(
                fileViewerState: _fileViewerState,
                scaffoldState: _fileViewerScaffoldKey.currentState,
              ),
            if (file.contentType == "application/pdf")
              PdfViewer(
                file: file,
                scaffoldState: _fileViewerScaffoldKey.currentState,
              ),
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
                  child:
                      InfoListTile(label: "Size", content: filesize(file.size)),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: InfoListTile(
                    label: "Created",
                    content: DateFormatting.formatDateFromSeconds(
                      timestamp: file.lastModified,
                    ),
                  ),
                ),
              ],
            ),
            InfoListTile(
                label: "Location", content: file.path == "" ? "/" : file.path),
            InfoListTile(label: "Owner", content: file.owner),
            PublicLinkSwitch(
              file: file,
              isFileViewer: true,
              updateFile: _updateFile,
              scaffoldKey: _fileViewerScaffoldKey,
            ),
            SizedBox(
              height: 16.0 + MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}
