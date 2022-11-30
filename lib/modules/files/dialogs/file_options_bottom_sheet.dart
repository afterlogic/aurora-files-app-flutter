import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/components/public_link_switch.dart';
import 'package:aurorafiles/modules/files/dialogs/leave_share_dialog.dart';
import 'package:aurorafiles/modules/files/dialogs/share_teammate_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/asset_icon.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/custom_bottom_sheet.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:secure_sharing/secure_sharing.dart';

import 'delete_confirmation_dialog.dart';
import 'rename_dialog_android.dart';
import 'share_dialog.dart';

enum FileOptionsBottomSheetResult {
  toggleOffline,
  download,
  cantShare,
  cantDownload,
}

class FileOptionsBottomSheet extends StatefulWidget {
  final BuildContext externalContext;
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;
  final bool canShare;
  final bool sharedWithMe;

  const FileOptionsBottomSheet._({
    Key? key,
    required this.externalContext,
    required this.file,
    required this.filesState,
    required this.filesPageState,
    required this.canShare,
    required this.sharedWithMe,
  }) : super(key: key);

  static Future show({
    required BuildContext context,
    required LocalFile file,
    required FilesState filesState,
    required FilesPageState filesPageState,
    required bool canShare,
    required bool sharedWithMe,
  }) {
    final isTablet = LayoutConfig.of(context).isTablet;
    if (isTablet) {
      return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AMDialog(
          content: SizedBox(
            width: LayoutConfig.formWidth,
            child: FileOptionsBottomSheet._(
              externalContext: context,
              file: file,
              filesState: filesState,
              filesPageState: filesPageState,
              canShare: canShare,
              sharedWithMe: sharedWithMe,
            ),
          ),
        ),
      );
    } else {
      return Navigator.push(
        context,
        CustomBottomSheet(
          child: FileOptionsBottomSheet._(
            externalContext: context,
            file: file,
            filesState: filesState,
            filesPageState: filesPageState,
            canShare: canShare,
            sharedWithMe: sharedWithMe,
          ),
        ),
      );
    }
  }

  @override
  _FileOptionsBottomSheetState createState() => _FileOptionsBottomSheetState();
}

class _FileOptionsBottomSheetState extends State<FileOptionsBottomSheet>
    with TickerProviderStateMixin {
  SecureSharing secureSharing = DI.get();
  late StorageType storageType;
  late bool isFolder;

  bool get _enableSecureLink => isFolder
      ? [StorageType.corporate, StorageType.personal].contains(storageType)
      : storageType != StorageType.shared;

  bool get _enableTeamShare =>
      storageType == StorageType.personal &&
      AppStore.settingsState.isTeamSharingEnable &&
      widget.canShare;

  @override
  void initState() {
    super.initState();
    storageType = StorageTypeHelper.toEnum(widget.file.type);
    isFolder = widget.file.isFolder;
  }

  Future<void> _downloadFile() async {
    bool canDownload = true;
    if (widget.file.initVector != null) {
      if (widget.file.encryptedDecryptionKey != null) {
        canDownload = await PgpKeyUtil.instance.hasUserKey();
      } else {
        canDownload = AppStore.settingsState.currentKey != null;
      }
    }
    if (canDownload) {
      onItemSelected(FileOptionsBottomSheetResult.download);
    } else {
      onItemSelected(FileOptionsBottomSheetResult.cantDownload);
    }
  }

  void _shareFile(BuildContext externalContext) async {
    final screenSize = MediaQuery.of(context).size;
    bool canDownload = true;
    if (widget.file.initVector != null) {
      if (widget.file.encryptedDecryptionKey != null) {
        canDownload = await PgpKeyUtil.instance.hasUserKey();
      } else {
        canDownload = AppStore.settingsState.currentKey != null;
      }
    }
    if (canDownload) {
      if (!mounted) return;
      Navigator.pop(context);
      final result = await AMDialog.show(
        context: externalContext,
        builder: (_) => ShareDialog(
          filesState: widget.filesState,
          file: widget.file,
        ),
      );
      if (result is PreparedForShare) {
        widget.filesState.shareFile(
          result,
          Rect.fromLTWH(0, 0, screenSize.width, screenSize.height / 2),
        );
      }
    } else {
      onItemSelected(FileOptionsBottomSheetResult.cantShare);
    }
  }

  void onItemSelected(FileOptionsBottomSheetResult result) {
    Navigator.pop(context, result);
  }

  void _copyOrMoveFile() {
    widget.filesState.updateFilesCb = widget.filesPageState.onGetFiles;
    widget.filesState.enableMoveMode(filesToMove: [widget.file]);
    Navigator.pop(context);
  }

  Future<void> _renameFile(BuildContext externalContext) async {
    Navigator.pop(context);
    await AMDialog.show(
      context: externalContext,
      builder: (_) => RenameDialog(
        file: widget.file,
        filesState: widget.filesState,
        filesPageState: widget.filesPageState,
      ),
    );
  }

  void _deleteFile(BuildContext externalContext) async {
    Navigator.pop(context);
    final shouldDelete = await AMDialog.show<bool>(
      context: externalContext,
      builder: (_) => DeleteConfirmationDialog(
        itemsNumber: 1,
        isFolder: widget.file.isFolder,
      ),
    );
    if (shouldDelete == true) {
      widget.filesPageState.onDeleteFiles(
        filesToDelete: [widget.file],
        storage: widget.filesState.selectedStorage,
        onSuccess: () => widget.filesPageState.onGetFiles(),
        onError: _onError,
      );
    }
  }

  Future<void> _secureSharing(BuildContext externalContext) async {
    final s = context.l10n;
    if (widget.file.published == false && widget.file.initVector != null) {
      if (widget.file.encryptedDecryptionKey == null) {
        Navigator.pop(context);
        return AMDialog.show(
          context: externalContext,
          builder: (_) => AMDialog(
            content: Text(s.error_backward_compatibility_sharing_not_supported),
            actions: [
              TextButton(
                child: Text(s.oK),
                onPressed: () => Navigator.pop(externalContext),
              ),
            ],
          ),
        );
      }
      return _secureEncryptSharing(
        externalContext,
        PreparedForShare(null, widget.file),
      );
    }
    final preparedForShare = PreparedForShare(null, widget.file);
    final pgpKeyUtil = PgpKeyUtil.instance;
    final userPrivateKey = await pgpKeyUtil.userPrivateKey();
    final userPublicKey = await pgpKeyUtil.userPublicKey();
    if (!mounted) return;
    Navigator.pop(context);
    await secureSharing.sharing(
      externalContext,
      widget.filesState,
      userPrivateKey,
      userPublicKey,
      pgpKeyUtil,
      preparedForShare,
    );
    widget.filesPageState.onGetFiles(
      showLoading: FilesLoadingType.filesVisible,
    );
  }

  Future<void> _secureEncryptSharing(
    BuildContext externalContext,
    PreparedForShare preparedForShare,
  ) async {
    final pgpKeyUtil = PgpKeyUtil.instance;
    final userPrivateKey = await pgpKeyUtil.userPrivateKey();
    final userPublicKey = await pgpKeyUtil.userPublicKey();
    if (!mounted) return;
    Navigator.pop(context);
    secureSharing.encryptSharing(
      externalContext,
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
  }

  Future<void> _shareWithTeammates(BuildContext externalContext) async {
    final s = context.l10n;
    Navigator.pop(context);
    if (widget.file.initVector != null &&
        widget.file.encryptedDecryptionKey == null) {
      return AMDialog.show(
        context: externalContext,
        builder: (_) => AMDialog(
          content: Text(s.error_backward_compatibility_sharing_not_supported),
          actions: [
            TextButton(
              child: Text(s.oK),
              onPressed: () => Navigator.pop(externalContext),
            ),
          ],
        ),
      );
    } else {
      final file = await AMDialog.show<LocalFile>(
        context: externalContext,
        builder: (_) => ShareTeammateDialog(
          fileState: widget.filesState,
          file: widget.file,
        ),
      );
      if (file is LocalFile) {
        widget.filesPageState
            .onGetFiles(showLoading: FilesLoadingType.filesVisible);
      }
    }
  }

  Future<void> _leaveShare(BuildContext externalContext) async {
    final result = await _confirmLeaveShare(externalContext);
    if (result == true) {
      try {
        await widget.filesState.leaveFileShare(widget.file);
      } catch (err) {
        _onError(err);
      }
      widget.filesPageState.onGetFiles();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<bool> _confirmLeaveShare(BuildContext externalContext) async {
    final result = await AMDialog.show<bool>(
      context: externalContext,
      builder: (_) => LeaveShareDialog(
        name: widget.file.name,
        isFolder: widget.file.isFolder,
      ),
    );
    return result == true;
  }

  void _onError(dynamic error) {
    AuroraSnackBar.showSnack(msg: '$error');
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final offline = widget.filesState.isOfflineMode;
    final isTablet = LayoutConfig.of(context).isTablet;
    final iconColor = Theme.of(context).iconTheme.color;

    Widget content = SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 0.0,
        bottom: isTablet ? 0 : MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        children: <Widget>[
          if (widget.file.initVector == null &&
              !offline &&
              !BuildProperty.secureSharingEnable)
            PublicLinkSwitch(
              file: widget.file,
              filesState: widget.filesState,
              filesPageState: widget.filesPageState,
            ),
          if (!isFolder && !offline) const Divider(height: 0),
          if (!isFolder)
            ListTile(
              onTap: () =>
                  onItemSelected(FileOptionsBottomSheetResult.toggleOffline),
              leading: Icon(Icons.airplanemode_active, color: iconColor),
              title: Text(s.offline),
              trailing: Switch.adaptive(
                activeColor: Theme.of(context).primaryColor,
                value: widget.file.localId != -1,
                onChanged: (bool val) =>
                    onItemSelected(FileOptionsBottomSheetResult.toggleOffline),
              ),
            ),
          const Divider(height: 0),
          if (!offline)
            ListTile(
              leading: Icon(isFolder ? MdiIcons.folderMove : MdiIcons.fileMove,
                  color: iconColor),
              title: Text(s.copy_or_move),
              onTap: _copyOrMoveFile,
            ),
          if (!offline &&
              BuildProperty.secureSharingEnable &&
              _enableSecureLink)
            ListTile(
              leading: AssetIcon(
                Asset.svg.insertLink,
                addedSize: 14,
                color: iconColor,
              ),
              title: Text(widget.file.initVector != null
                  ? s.btn_encrypted_shareable_link
                  : s.btn_shareable_link),
              onTap: () => _secureSharing(widget.externalContext),
            ),
          if (!offline && _enableTeamShare)
            ListTile(
              leading: Icon(Icons.share, color: iconColor),
              title: Text(s.label_share_with_teammates),
              onTap: () => _shareWithTeammates(widget.externalContext),
            ),
          if (!offline && widget.sharedWithMe)
            ListTile(
              leading: SvgPicture.asset(
                Asset.svg.iconShareLeave,
                width: 24,
                height: 24,
                color: iconColor,
              ),
              title: Text(s.label_leave_share),
              onTap: () => _leaveShare(widget.externalContext),
            ),
          if (!isFolder)
            ListTile(
              leading: Icon(
                  PlatformOverride.isIOS ? MdiIcons.exportVariant : Icons.share,
                  color: iconColor),
              title: Text(s.share),
              onTap: () => _shareFile(widget.externalContext),
            ),
          if (!PlatformOverride.isIOS && !isFolder)
            ListTile(
              leading: Icon(Icons.file_download, color: iconColor),
              title: Text(s.download),
              onTap: _downloadFile,
            ),
          if (!offline)
            ListTile(
              leading: Icon(Icons.edit, color: iconColor),
              title: Text(s.rename),
              onTap: () => _renameFile(widget.externalContext),
            ),
          if (!offline)
            ListTile(
              leading: Icon(Icons.delete_outline, color: iconColor),
              title: Text(s.delete),
              onTap: () => _deleteFile(widget.externalContext),
            ),
        ],
      ),
    );

    if (!isTablet) {
      content = LimitedBox(
        maxHeight: offline ? 180.0 : 260.0,
        child: content,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.file.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const Divider(height: 0),
        content,
      ],
    );
  }
}
