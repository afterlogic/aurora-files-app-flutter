import 'dart:convert';
import 'dart:io';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/share_access_right.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/components/public_link_switch.dart';
import 'package:aurorafiles/modules/files/dialogs/delete_confirmation_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/key_request_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/leave_share_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/rename_dialog_android.dart';
import 'package:aurorafiles/modules/files/dialogs/share_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/share_teammate_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/components/image_viewer.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/components/info_list_tile.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/components/pdf_viewer.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/components/text_viewer.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/asset_icon.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:secure_sharing/secure_sharing.dart';

class FileViewerAndroid extends StatefulWidget {
  final LocalFile immutableFile;
  final FilesState filesState;
  final FilesPageState filesPageState;
  final File? offlineFile;

  const FileViewerAndroid({
    Key? key,
    required this.immutableFile,
    required this.filesState,
    required this.filesPageState,
    this.offlineFile,
  }) : super(key: key);

  @override
  _FileViewerAndroidState createState() => _FileViewerAndroidState();
}

class _FileViewerAndroidState extends State<FileViewerAndroid> {
  final _fileViewerScaffoldKey = GlobalKey<ScaffoldState>();
  SecureSharing secureSharing = DI.get();
  final _fileViewerState = FileViewerState();
  late LocalFile _file;
  late FileType _fileType;
  bool _showEncrypt = false;
  bool _isFileOffline = false;
  bool _isSyncingForOffline = false;
  String? password;
  late StorageType storageType;
  late bool isFolder;
  Map<String, dynamic> _extendedProps = {};
  bool _hasShares = false;
  ShareAccessRight? _sharedWithMeAccess;

  bool get _sharedWithMe => _sharedWithMeAccess != null;

  bool get _canShared =>
      _sharedWithMeAccess == null ||
      _sharedWithMeAccess == ShareAccessRight.readWriteReshare;

  bool get _enableSecureLink => isFolder
      ? [StorageType.corporate, StorageType.personal].contains(storageType)
      : storageType != StorageType.shared;

  bool get _enableTeamShare =>
      storageType == StorageType.personal &&
      AppStore.settingsState.isTeamSharingEnable &&
      _canShared;

  @override
  void initState() {
    super.initState();
    _fileViewerState.fileState = widget.filesState;
    _file = widget.immutableFile;
    _isFileOffline = _file.localId != -1;
    _fileViewerState.file = widget.immutableFile;
    if (widget.offlineFile != null) {
      _fileViewerState.fileWithContents = widget.offlineFile;
    }
    _fileType = getFileType(_file);
    storageType = StorageTypeHelper.toEnum(widget.immutableFile.type);
    isFolder = widget.immutableFile.isFolder;
    _initExtendedProps();
    _initShareProps();
  }

  @override
  void dispose() {
    super.dispose();
    // delete files that did not finish their caching
    if (_fileViewerState.processingFile != null) {
      _fileViewerState.processingFile?.subscription?.cancel();
      _fileViewerState.processingFile?.fileOnDevice.delete();
    }
  }

  void _initExtendedProps() {
    if (_file.extendedProps.isNotEmpty) {
      try {
        _extendedProps = jsonDecode(_file.extendedProps);
      } catch (err) {
        print('extendedProps decode ERROR: $err');
      }
    }
  }

  void _initShareProps() {
    if (_extendedProps.containsKey("Shares")) {
      final list = _extendedProps["Shares"] as List;
      _hasShares = list.isNotEmpty;
    }
    if (_extendedProps.containsKey("SharedWithMeAccess")) {
      final code = _extendedProps["SharedWithMeAccess"] as int;
      _sharedWithMeAccess = ShareAccessRightHelper.fromCode(code);
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
    Navigator.pop(context, _file);
  }

  void _shareFile(PreparedForShare preparedForShare) {
    final screenSize = MediaQuery.of(context).size;
    widget.filesState.shareFile(
      preparedForShare,
      Rect.fromLTWH(0, 0, screenSize.width, screenSize.height / 2),
    );
  }

  void _prepareShareFile(Function(PreparedForShare) complete) async {
    final s = context.l10n;
    if (_fileViewerState.fileWithContents != null) {
      widget.filesState.prepareForShare(
        _file,
        context,
        storedFile: _fileViewerState.fileWithContents,
        onStart: (_) {},
        onSuccess: complete,
        onError: _onError,
      );
    } else if (_fileViewerState.downloadProgress != null) {
      AuroraSnackBar.showSnack(
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
    final shouldDelete = await AMDialog.show<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        itemsNumber: 1,
        isFolder: _file.isFolder,
      ),
    );
    if (shouldDelete == true) {
      widget.filesPageState.onDeleteFiles(
        filesToDelete: [_file],
        storage: widget.filesState.selectedStorage,
        onSuccess: () {
          widget.filesPageState.onGetFiles();
        },
        onError: (String err) {
          widget.filesPageState.filesLoading = FilesLoadingType.none;
          _onError(err);
        },
      );
      widget.filesPageState.filesLoading = FilesLoadingType.filesVisible;
      if (!mounted) return;
      Navigator.pop(context, _file);
    }
  }

  void _downloadFile() {
    final s = context.l10n;
    widget.filesState.onDownloadFile(
      context,
      file: _file,
      onStart: (ProcessingFile process) {
        // TODO VO: update ui without refreshing files
        widget.filesPageState
            .onGetFiles(showLoading: FilesLoadingType.filesHidden);
        AuroraSnackBar.showSnack(
          msg: s.downloading(_file.name),
          isError: false,
        );
      },
      onSuccess: (File savedFile) => AuroraSnackBar.showSnack(
        msg: s.downloaded_successfully_into(_file.name, savedFile.path),
        isError: false,
        duration: const Duration(minutes: 10),
        action: SnackBarAction(
          label: s.oK,
          onPressed: () => AuroraSnackBar.hideSnack(),
        ),
      ),
      onError: _onError,
    );
  }

  Future<void> _setFileForOffline() async {
    final s = context.l10n;
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
            if (!mounted) return;
            Navigator.pop(context, _file);
          },
          onError: (err) => _fileViewerState.processingFile = null);
    } else {
      try {
        setState(() {
          _isSyncingForOffline = true;
          _isFileOffline = !_isFileOffline;
        });
        if (_file.localId == -1) {
          AuroraSnackBar.showSnack(
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
              if (_file.localId == -1) {
                AuroraSnackBar.showSnack(
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
        _onError(err);
      }
    }
  }

  Future<void> _shareWithTeammates() async {
    final s = context.l10n;
    if (widget.immutableFile.initVector != null &&
        widget.immutableFile.encryptedDecryptionKey == null) {
      return AMDialog.show(
        context: context,
        builder: (_) => AMDialog(
          content: Text(s.error_backward_compatibility_sharing_not_supported),
          actions: [
            TextButton(
              child: Text(s.oK),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      final file = await AMDialog.show(
        context: context,
        builder: (_) => ShareTeammateDialog(
          fileState: widget.filesState,
          file: _file,
        ),
      );
      if (file is LocalFile) {
        _file = file;
        widget.filesPageState
            .onGetFiles(showLoading: FilesLoadingType.filesVisible);
        setState(() {});
      }
    }
  }

  Future<void> _leaveShare(BuildContext context) async {
    final result = await _confirmLeaveShare();
    if (result == true) {
      try {
        await widget.filesState.leaveFileShare(_file);
      } catch (err) {
        _onError(err);
      }
      widget.filesPageState.onGetFiles();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<bool> _confirmLeaveShare() async {
    final result = await AMDialog.show<bool>(
      context: context,
      builder: (_) => LeaveShareDialog(
        name: _file.name,
        isFolder: _file.isFolder,
      ),
    );
    return result == true;
  }

  Future<void> _secureSharing() async {
    final s = context.l10n;
    if (_file.published == false && widget.immutableFile.initVector != null) {
      if (widget.immutableFile.encryptedDecryptionKey == null) {
        return AMDialog.show(
          context: context,
          builder: (_) => AMDialog(
            content: Text(s.error_backward_compatibility_sharing_not_supported),
            actions: [
              TextButton(
                child: Text(s.oK),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
      return _secureEncryptSharing(PreparedForShare(null, _file));
    }
    final preparedForShare = PreparedForShare(null, _file);
    final pgpKeyUtil = PgpKeyUtil.instance;
    final userPrivateKey = await pgpKeyUtil.userPrivateKey();
    final userPublicKey = await pgpKeyUtil.userPublicKey();
    if (!mounted) return;
    await secureSharing.sharing(
      context,
      widget.filesState,
      userPrivateKey,
      userPublicKey,
      pgpKeyUtil,
      preparedForShare,
    );
    _file = preparedForShare.localFile;
    setState(() {});
  }

  Future<void> _secureEncryptSharing(PreparedForShare preparedForShare) async {
    final pgpKeyUtil = PgpKeyUtil.instance;
    final userPrivateKey = await pgpKeyUtil.userPrivateKey();
    final userPublicKey = await pgpKeyUtil.userPublicKey();
    if (!mounted) return;
    secureSharing.encryptSharing(
      context,
      widget.filesState,
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
    );
    _file = preparedForShare.localFile;
    setState(() {});
  }

  Widget _getPreviewContent(BuildContext context) {
    final s = context.l10n;
    const previewIconSize = 120.0;
    Widget result;
    if (_file.initVector != null && _showEncrypt == false) {
      result = Column(
        children: <Widget>[
          Icon(Icons.lock_outline,
              size: previewIconSize, color: Theme.of(context).disabledColor),
          if ([FileType.image, FileType.text, FileType.code]
              .contains(_fileType))
            TextButton(
              child: Text(s.btn_show_encrypt),
              onPressed: () async {
                if (widget.immutableFile.encryptedDecryptionKey != null) {
                  password = await KeyRequestDialog.request(context);
                  if (password == null) return;
                }
                _showEncrypt = true;
                setState(() {});
              },
            )
        ],
      );
    } else {
      switch (_fileType) {
        case FileType.image:
          result = ImageViewer(
            password: password,
            fileViewerState: _fileViewerState,
            scaffoldState: _fileViewerScaffoldKey.currentState,
          );
          break;
        case FileType.svg:
          result = Icon(MdiIcons.fileImageOutline,
              size: previewIconSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.text:
        case FileType.code:
          result = TextViewer(
            password: password,
            fileViewerState: _fileViewerState,
            scaffoldState: _fileViewerScaffoldKey.currentState,
          );
          break;
        case FileType.pdf:
          result = PdfViewer(
            file: _file,
            scaffoldState: _fileViewerScaffoldKey.currentState,
          );
          break;
        case FileType.zip:
          result = Icon(MdiIcons.zipBoxOutline,
              size: previewIconSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.unknown:
          result = Icon(MdiIcons.fileOutline,
              size: previewIconSize, color: Theme.of(context).disabledColor);
          break;
        default:
          result = Icon(MdiIcons.fileOutline,
              size: previewIconSize, color: Theme.of(context).disabledColor);
      }
    }
    return result;
  }

  void _onError(dynamic error) {
    AuroraSnackBar.showSnack(msg: '$error');
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? Theme.of(context).iconTheme.color
        : Theme.of(context).disabledColor;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _file);
        return false;
      },
      child: MultiProvider(
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
                      onPressed: () => _shareFile(
                        PreparedForShare(
                          File(widget.immutableFile.localPath),
                          widget.immutableFile,
                        ),
                      ),
                    ),
                    if (!PlatformOverride.isIOS)
                      IconButton(
                        icon: const Icon(Icons.file_download),
                        tooltip: s.download,
                        onPressed: _downloadFile,
                      ),
                  ]
                : [
                    if (BuildProperty.secureSharingEnable && _enableSecureLink)
                      IconButton(
                        icon: AssetIcon(
                          Asset.svg.insertLink,
                          addedSize: 14,
                        ),
                        tooltip: widget.immutableFile.initVector != null
                            ? s.btn_encrypted_shareable_link
                            : s.btn_shareable_link,
                        onPressed: _secureSharing,
                      ),
                    if (_file.downloadUrl.isNotEmpty && !PlatformOverride.isIOS)
                      IconButton(
                        icon: const Icon(Icons.file_download),
                        tooltip: s.download,
                        onPressed: _downloadFile,
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: s.delete_file,
                      onPressed: _deleteFile,
                    ),
                    PopupMenuButton<Function>(
                      onSelected: (fn) => fn(),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: () => _prepareShareFile(_shareFile),
                          child: ListTile(
                            leading: Icon(
                                PlatformOverride.isIOS
                                    ? MdiIcons.exportVariant
                                    : Icons.share,
                                color: iconColor),
                            title: Text(s.share),
                          ),
                        ),
                        if (_enableTeamShare)
                          PopupMenuItem(
                            value: _shareWithTeammates,
                            child: ListTile(
                              leading: Icon(Icons.share, color: iconColor),
                              title: Text(s.label_share_with_teammates),
                            ),
                          ),
                        if (_sharedWithMe)
                          PopupMenuItem(
                            value: () => _leaveShare(context),
                            child: ListTile(
                              leading: SvgPicture.asset(
                                Asset.svg.iconShareLeave,
                                width: 24,
                                height: 24,
                                color: iconColor,
                              ),
                              title: Text(s.label_leave_share),
                            ),
                          ),
                        PopupMenuItem(
                          value: _moveFile,
                          child: ListTile(
                            leading: Icon(MdiIcons.fileMove, color: iconColor),
                            title: Text(s.copy_or_move),
                          ),
                        ),
                        PopupMenuItem(
                          value: _renameFile,
                          child: ListTile(
                            leading: Icon(Icons.edit, color: iconColor),
                            title: Text(s.rename),
                          ),
                        ),
                      ],
                    ),
                  ],
          ),
          body: Stack(
            alignment: Alignment.topRight,
            children: [
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: _getPreviewContent(context),
                  ),
                  InfoListTile(
                    label: s.filename,
                    content: _file.name,
                    isPublic: _file.published,
                    isShared: _hasShares,
                    isOffline: _file.localId != -1,
                    isEncrypted: _file.initVector != null,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InfoListTile(
                          label: s.size,
                          content: filesize(_file.size),
                        ),
                      ),
                      const SizedBox(width: 30),
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
                      label: s.location, content: _file.type + _file.path),
                  InfoListTile(label: s.owner, content: _file.owner),
                  if (!widget.filesState.isOfflineMode &&
                      !BuildProperty.secureSharingEnable)
                    PublicLinkSwitch(
                      file: _file,
                      isFileViewer: true,
                      updateFile: _updateFile,
                      scaffoldKey: _fileViewerScaffoldKey,
                    ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: _isSyncingForOffline ? null : _setFileForOffline,
                    leading: Icon(Icons.airplanemode_active, color: iconColor),
                    title: Text(s.offline),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).primaryColor,
                      value: _isFileOffline,
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
              if (_sharedWithMe)
                SvgPicture.asset(
                  Asset.svg.iconSharedWithMeBig,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
