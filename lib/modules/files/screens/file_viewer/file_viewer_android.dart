import 'dart:io';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/components/public_link_switch.dart';
import 'package:aurorafiles/modules/files/dialogs/delete_confirmation_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/rename_dialog_android.dart';
import 'package:aurorafiles/modules/files/dialogs/share_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/share_to_email_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/components/pdf_viewer.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/asset_icon.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:secure_sharing/secure_sharing.dart';

import 'components/image_viewer.dart';
import 'components/info_list_tile.dart';
import 'components/text_viewer.dart';

class FileViewerAndroid extends StatefulWidget {
  final LocalFile immutableFile;
  final File offlineFile;
  final FilesState filesState;
  final FilesPageState filesPageState;

  FileViewerAndroid({
    Key key,
    @required this.immutableFile,
    @required this.offlineFile,
    @required this.filesState,
    @required this.filesPageState,
  }) : super(key: key);

  @override
  _FileViewerAndroidState createState() => _FileViewerAndroidState();
}

class _FileViewerAndroidState extends State<FileViewerAndroid> {
  final _fileViewerScaffoldKey = GlobalKey<ScaffoldState>();
  SecureSharing secureSharing = DI.get();
  final _fileViewerState = FileViewerState();
  S s;
  LocalFile _file;
  FileType _fileType;

  bool _isFileOffline = false;
  bool _isSyncingForOffline = false;

  @override
  void initState() {
    super.initState();
    _fileViewerState.fileState = widget.filesState;
    _file = widget.immutableFile;
    _isFileOffline = _file.localId != null;
    _fileViewerState.file = widget.immutableFile;
    if (widget.offlineFile != null) {
      _fileViewerState.fileWithContents = widget.offlineFile;
    }
    _fileType = getFileType(_file);
  }

  @override
  void dispose() {
    super.dispose();
    // delete files that did not finish their caching
    if (_fileViewerState.processingFile != null) {
      _fileViewerState.processingFile.subscription?.cancel();
      _fileViewerState.processingFile.fileOnDevice?.delete();
    }
  }

  void _updateFile(String fileId) {
    widget.filesPageState.currentFiles.forEach((updatedFile) {
      if (updatedFile.id == fileId) {
        _fileViewerState.file = updatedFile;
        setState(() => _file = updatedFile);
      }
    });
  }

  void _moveFile() {
    widget.filesState.updateFilesCb = widget.filesPageState.onGetFiles;
    widget.filesState.enableMoveMode(filesToMove: [_file]);
    Navigator.pop(context);
  }

  void _shareFile(PreparedForShare preparedForShare) {
    widget.filesState.share(preparedForShare);
  }

  void _prepareShareFile(Function(PreparedForShare) complete) async {
    if (_fileViewerState.fileWithContents != null) {
      widget.filesState.prepareForShare(
        _file,
        context,
        storedFile: _fileViewerState.fileWithContents,
        onSuccess: complete,
        onError: (String err) => showSnack(
          context: context,
          scaffoldState: _fileViewerScaffoldKey.currentState,
          msg: err,
        ),
      );
    } else if (_fileViewerState.downloadProgress != null) {
      showSnack(
        context: context,
        scaffoldState: _fileViewerScaffoldKey.currentState,
        msg: s.please_wait_until_loading,
        isError: false,
      );
    } else {
      final result = await AMDialog.show(
        context: context,
        builder: (_) => ShareDialog(
          filesState: widget.filesState,
          file: _file,
        ),
      );

      if (result is PreparedForShare) {
        complete(result);
      }
    }
  }

  void _renameFile() async {
    final result = await AMDialog.show(
      context: context,
      builder: (_) => RenameDialog(
        file: _file,
        filesState: widget.filesState,
        filesPageState: widget.filesPageState,
      ),
    );
    if (result is String) {
      _updateFile(result);
    }
  }

  void _deleteFile() async {
    final shouldDelete = await AMDialog.show(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        itemsNumber: 1,
        isFolder: false,
      ),
    );
    if (shouldDelete != null && shouldDelete) {
      widget.filesPageState.onDeleteFiles(
        filesToDelete: [_file],
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
      context,
      file: _file,
      onStart: (ProcessingFile process) {
        // TODO VO: update ui without refreshing files
        widget.filesPageState
            .onGetFiles(showLoading: FilesLoadingType.filesHidden);
        showSnack(
          context: context,
          scaffoldState: _fileViewerScaffoldKey.currentState,
          msg: s.downloading(_file.name),
          isError: false,
        );
      },
      onSuccess: (File savedFile) => showSnack(
          context: context,
          scaffoldState: _fileViewerScaffoldKey.currentState,
          msg: s.downloaded_successfully_into(_file.name, savedFile.path),
          isError: false,
          duration: Duration(minutes: 10),
          action: SnackBarAction(
            label: s.oK,
            onPressed: _fileViewerScaffoldKey.currentState.hideCurrentSnackBar,
          )),
      onError: (String err) => showSnack(
        context: context,
        scaffoldState: _fileViewerScaffoldKey.currentState,
        msg: err,
      ),
    );
  }

  Future _setFileForOffline() async {
    if (widget.filesState.isOfflineMode) {
      widget.filesState.onSetFileOffline(_file, context,
          onStart: (process) {
            _fileViewerState.processingFile = process;
            widget.filesPageState
                .onGetFiles(showLoading: FilesLoadingType.filesHidden);
          },
          onSuccess: () async {
            _fileViewerState.processingFile = null;
            await widget.filesPageState.onGetFiles();
            Navigator.pop(context);
          },
          onError: (err) => _fileViewerState.processingFile = null);
    } else {
      try {
        setState(() {
          _isSyncingForOffline = true;
          _isFileOffline = !_isFileOffline;
        });
        if (_file.localId == null) {
          showSnack(
            context: context,
            scaffoldState: _fileViewerScaffoldKey.currentState,
            msg: s.synch_file_progress,
            isError: false,
          );
        }
        await widget.filesState.onSetFileOffline(_file, context,
            onStart: (process) {
              _fileViewerState.processingFile = process;
              widget.filesPageState
                  .onGetFiles(showLoading: FilesLoadingType.filesHidden);
            },
            onSuccess: () async {
              _fileViewerState.processingFile = null;
              if (_file.localId == null) {
                showSnack(
                  context: context,
                  scaffoldState: _fileViewerScaffoldKey.currentState,
                  msg: s.synched_successfully,
                  isError: false,
                );
              }
              await widget.filesPageState.onGetFiles();
              _updateFile(_file.id);
              setState(() => _isSyncingForOffline = false);
            },
            onError: (err) => _fileViewerState.processingFile = null);
      } catch (err) {
        setState(() {
          _isSyncingForOffline = false;
          _isFileOffline = !_isFileOffline;
        });
        showSnack(
          context: context,
          scaffoldState: _fileViewerScaffoldKey.currentState,
          msg: err.toString(),
        );
      }
    }
  }

  _secureSharing() async {
    if (widget.immutableFile.encryptedDecryptionKey != null) {
      return _prepareShareFile(_secureEncryptSharing);
    }
    final preparedForShare = PreparedForShare(null, _file);
    final pgpKeyUtil = PgpKeyUtil.instance;
    final userPrivateKey = await pgpKeyUtil.userPrivateKey();
    final userPublicKey = await pgpKeyUtil.userPublicKey();
    await secureSharing.sharing(
      context,
      widget.filesState,
      _fileViewerState,
      userPrivateKey,
      userPublicKey,
      pgpKeyUtil,
      preparedForShare,
      s,
    );
    _file = preparedForShare.localFile;
    await widget.filesState
        .updateFile(getCompanionFromLocalFile(preparedForShare.localFile));
    setState(() {});
  }

  _secureEncryptSharing(PreparedForShare preparedForShare) async {
    final pgpKeyUtil = PgpKeyUtil.instance;
    final userPrivateKey = await pgpKeyUtil.userPrivateKey();
    final userPublicKey = await pgpKeyUtil.userPublicKey();
    secureSharing.encryptSharing(
      context,
      widget.filesState,
      _fileViewerState,
      userPrivateKey,
      userPublicKey,
      pgpKeyUtil,
      preparedForShare,
      () {
        widget.filesPageState.onGetFiles(
          showLoading: FilesLoadingType.filesVisible,
        );
      },
      DI.get(),
      s,
    );
    _file = preparedForShare.localFile;
    setState(() {});
  }

  Widget _getPreviewContent() {
    final previewIconSize = 120.0;
    if (_file.initVector != null) {
      return Icon(Icons.lock_outline,
          size: previewIconSize, color: Theme.of(context).disabledColor);
    }
    switch (_fileType) {
      case FileType.image:
        return ImageViewer(
          fileViewerState: _fileViewerState,
          scaffoldState: _fileViewerScaffoldKey.currentState,
        );
      case FileType.text:
      case FileType.code:
        return TextViewer(
          fileViewerState: _fileViewerState,
          scaffoldState: _fileViewerScaffoldKey.currentState,
        );
      case FileType.pdf:
        return PdfViewer(
          file: _file,
          scaffoldState: _fileViewerScaffoldKey.currentState,
        );
      case FileType.zip:
        return Icon(MdiIcons.zipBoxOutline,
            size: previewIconSize, color: Theme.of(context).disabledColor);

      case FileType.unknown:
        return Icon(MdiIcons.fileOutline,
            size: previewIconSize, color: Theme.of(context).disabledColor);
      default:
        return Icon(MdiIcons.fileOutline,
            size: previewIconSize, color: Theme.of(context).disabledColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final theme = Theme.of(context);
    return MultiProvider(
      providers: [
        Provider<FilesState>(
          create: (_) => widget.filesState,
        ),
        Provider<FilesPageState>(
          create: (_) => widget.filesPageState,
        ),
        Provider<AuthState>(
          create: (_) => AppStore.authState,
        ),
      ],
      child: Scaffold(
        key: _fileViewerScaffoldKey,
        appBar: AMAppBar(
          actions: widget.filesState.isOfflineMode
              ? [
                  IconButton(
                    icon: Icon(PlatformOverride.isIOS
                        ? MdiIcons.exportVariant
                        : Icons.share),
                    tooltip: s.share,
                    onPressed: () => _prepareShareFile(_shareFile),
                  ),
                  if (!PlatformOverride.isIOS)
                    IconButton(
                      icon: Icon(Icons.file_download),
                      tooltip: s.download,
                      onPressed: _downloadFile,
                    ),
                  IconButton(
                    icon: Icon(Icons.airplanemode_inactive),
                    tooltip: s.delete_from_offline,
                    onPressed: _setFileForOffline,
                  ),
                ]
              : [
                  if (BuildProperty.secureSharingEnable)
                    IconButton(
                      icon: AssetIcon(
                        "lib/assets/svg/insert_link.svg",
                        addedSize: 14,
                      ),
                      tooltip: s.secure_sharing,
                      onPressed: _secureSharing,
                    ),
                  if (_file.downloadUrl != null && !PlatformOverride.isIOS)
                    IconButton(
                      icon: Icon(Icons.file_download),
                      tooltip: s.download,
                      onPressed: _downloadFile,
                    ),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    tooltip: s.delete_file,
                    onPressed: _deleteFile,
                  ),
                  PopupMenuButton<Function>(
                    onSelected: (fn) => fn(),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: () => _prepareShareFile(_shareFile),
                        child: ListTile(
                          leading: Icon(PlatformOverride.isIOS
                              ? MdiIcons.exportVariant
                              : Icons.share),
                          title: Text(s.share),
                        ),
                      ),
                      if (_file.type != "shared")
                        PopupMenuItem(
                          value: () => AMDialog.show(
                            context: context,
                            builder: (_) => ShareToEmailDialog(
                              widget.filesState,
                              _file,
                              context,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(PlatformOverride.isIOS
                                ? MdiIcons.exportVariant
                                : Icons.share),
                            title: Text(s.btn_share_to_email),
                          ),
                        ),
                      PopupMenuItem(
                        value: _moveFile,
                        child: ListTile(
                          leading: Icon(MdiIcons.fileMove),
                          title: Text(s.copy_or_move),
                        ),
                      ),
                      PopupMenuItem(
                        value: _renameFile,
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text(s.rename),
                        ),
                      ),
                    ],
                  ),
                ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: _getPreviewContent(),
            ),
            InfoListTile(
              label: s.filename,
              content: _file.name,
              isPublic: _file.published,
              isOffline: _file.localId != null,
              isEncrypted: _file.initVector != null,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InfoListTile(
                      label: s.size, content: filesize(_file.size)),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: InfoListTile(
                    label: s.created,
                    content: DateFormatting.formatDateFromSeconds(
                      timestamp: _file.lastModified,
                    ),
                  ),
                ),
              ],
            ),
            InfoListTile(
                label: s.location,
                content: _file.path == "" ? "/" : _file.path),
            InfoListTile(label: s.owner, content: _file.owner),
            if (!widget.filesState.isOfflineMode &&
                !BuildProperty.secureSharingEnable)
              PublicLinkSwitch(
                file: _file,
                isFileViewer: true,
                updateFile: _updateFile,
                scaffoldKey: _fileViewerScaffoldKey,
              ),
            if (!widget.filesState.isOfflineMode) Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: _isSyncingForOffline ? null : _setFileForOffline,
              leading: Icon(Icons.airplanemode_active),
              title: Text(s.offline),
              trailing: Switch.adaptive(
                value: _isFileOffline,
                activeColor: Theme.of(context).accentColor,
                onChanged: _isSyncingForOffline
                    ? null
                    : (bool val) => _setFileForOffline(),
              ),
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
