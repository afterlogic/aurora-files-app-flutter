import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
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
import 'package:aurorafiles/shared_ui/custom_bottom_sheet.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:aurorafiles/utils/show_snack.dart';
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
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;
  final bool canShare;
  final bool sharedWithMe;

  const FileOptionsBottomSheet._({
    Key? key,
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
  late S s;
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

  void _download() async {
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

  void _shareFile() async {
    final bottomCenter = MediaQuery.of(context).size.bottomCenter(Offset.zero);
    bool canDownload = true;
    if (widget.file.initVector != null) {
      if (widget.file.encryptedDecryptionKey != null) {
        canDownload = await PgpKeyUtil.instance.hasUserKey();
      } else {
        canDownload = AppStore.settingsState.currentKey != null;
      }
    }
    if (canDownload) {
      Navigator.pop(context);
      final result = await AMDialog.show(
        context: context,
        builder: (_) => ShareDialog(
          filesState: widget.filesState,
          file: widget.file,
        ),
      );
      if (result is PreparedForShare) {
        widget.filesState.share(
          result,
          Rect.fromCenter(
            center: bottomCenter,
            width: 0,
            height: 0,
          ),
        );
      }
    } else {
      onItemSelected(FileOptionsBottomSheetResult.cantShare);
    }
  }

  void onItemSelected(FileOptionsBottomSheetResult result) {
    Navigator.pop(context, result);
  }

  void _deleteFile() async {
    final shouldDelete = await AMDialog.show<bool>(
            context: context,
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

  Future<void> _secureSharing() async {
    if (widget.file.published == false && widget.file.initVector != null) {
      if (widget.file.encryptedDecryptionKey == null) {
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
      return _secureEncryptSharing(PreparedForShare(null, widget.file));
    }
    final preparedForShare = PreparedForShare(null, widget.file);
    final pgpKeyUtil = PgpKeyUtil.instance;
    final userPrivateKey = await pgpKeyUtil.userPrivateKey();
    final userPublicKey = await pgpKeyUtil.userPublicKey();
    await secureSharing.sharing(
      context,
      widget.filesState,
      userPrivateKey,
      userPublicKey,
      pgpKeyUtil,
      preparedForShare,
      s,
    );

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
    setState(() {});
  }

  Future<void> _shareWithTeammates(BuildContext context) async {
    Navigator.pop(context);
    if (widget.file.initVector != null &&
        widget.file.encryptedDecryptionKey == null) {
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
      final file = await AMDialog.show<LocalFile>(
        context: context,
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

  Future<void> _leaveShare(BuildContext context) async {
    final result = await _confirmLeaveShare();
    if (result == true) {
      try {
        await widget.filesState.leaveFileShare(widget.file);
      } catch (err) {
        _onError(err);
      }
      widget.filesPageState.onGetFiles();
      Navigator.pop(context);
    }
  }

  Future<bool> _confirmLeaveShare() async {
    final result = await AMDialog.show<bool>(
      context: context,
      builder: (_) => LeaveShareDialog(
        name: widget.file.name,
        isFolder: widget.file.isFolder,
      ),
    );
    return result == true;
  }

  void _onError(dynamic error) {
    showSnack(context, msg: '$error');
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final offline = widget.filesState.isOfflineMode;
    final isTablet = LayoutConfig.of(context).isTablet;
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
          if (!isFolder && !offline) Divider(height: 0),
          if (!isFolder)
            ListTile(
              onTap: () =>
                  onItemSelected(FileOptionsBottomSheetResult.toggleOffline),
              leading: Icon(Icons.airplanemode_active),
              title: Text(s.offline),
              trailing: Switch.adaptive(
                value: widget.file.localId != -1,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (bool val) =>
                    onItemSelected(FileOptionsBottomSheetResult.toggleOffline),
              ),
            ),
          Divider(height: 0),
          if (!offline)
            ListTile(
              leading: Icon(isFolder ? MdiIcons.folderMove : MdiIcons.fileMove),
              title: Text(s.copy_or_move),
              onTap: () {
                widget.filesState.updateFilesCb =
                    widget.filesPageState.onGetFiles;
                widget.filesState.enableMoveMode(filesToMove: [widget.file]);
                Navigator.pop(context);
              },
            ),
          if (!offline &&
              BuildProperty.secureSharingEnable &&
              _enableSecureLink)
            ListTile(
              leading: AssetIcon(
                Asset.svg.insertLink,
                addedSize: 14,
              ),
              title: Text(widget.file.initVector != null
                  ? s.btn_encrypted_shareable_link
                  : s.btn_shareable_link),
              onTap: _secureSharing,
            ),
          if (!offline && _enableTeamShare)
            ListTile(
              leading: Icon(Icons.share),
              title: Text(s.label_share_with_teammates),
              onTap: () => _shareWithTeammates(context),
            ),
          if (!offline && widget.sharedWithMe)
            ListTile(
              leading: SvgPicture.asset(
                Asset.svg.iconShareLeave,
                width: 24,
                height: 24,
                color: Theme.of(context).disabledColor,
              ),
              title: Text(s.label_leave_share),
              onTap: () => _leaveShare(context),
            ),
          if (!isFolder)
            ListTile(
              leading: Icon(PlatformOverride.isIOS
                  ? MdiIcons.exportVariant
                  : Icons.share),
              title: Text(s.share),
              onTap: _shareFile,
            ),
          if (!PlatformOverride.isIOS && !isFolder)
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text(s.download),
              onTap: _download,
            ),
          if (!offline)
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(s.rename),
              onTap: () async {
                Navigator.pop(context);
                await AMDialog.show(
                  context: context,
                  builder: (_) => RenameDialog(
                    file: widget.file,
                    filesState: widget.filesState,
                    filesPageState: widget.filesPageState,
                  ),
                );
              },
            ),
          if (!offline)
            ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text(s.delete),
              onTap: () {
                Navigator.pop(context);
                _deleteFile();
              },
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
        Divider(height: 0),
        content,
      ],
    );
  }


}
