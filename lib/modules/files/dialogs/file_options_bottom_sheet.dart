import 'dart:io';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/di/di.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/components/public_link_switch.dart';
import 'package:aurorafiles/modules/files/dialogs/share_to_email_dialog.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/asset_icon.dart';
import 'package:aurorafiles/utils/offline_utils.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'delete_confirmation_dialog.dart';
import 'rename_dialog_android.dart';
import 'share_dialog.dart';

import 'package:secure_sharing/secure_sharing.dart';

enum FileOptionsBottomSheetResult {
  toggleOffline,
  download,
  cantShare,
}

class FileOptionsBottomSheet extends StatefulWidget {
  final LocalFile file;
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
  S s;
  SecureSharing secureSharing = DI.get();

  void _shareFile() async {
    final hasDecryptKey = await PgpKeyUtil.instance.hasUserKey();
    final hasVector = widget.file.initVector != null;
    final canDownload = !(hasVector && !hasDecryptKey);
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
        widget.filesState.share(result);
      }
    } else {
      onItemSelected(FileOptionsBottomSheetResult.cantShare);
    }
  }

  void onItemSelected(FileOptionsBottomSheetResult result) {
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    final offline = widget.filesState.isOfflineMode;
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
          maxHeight: offline ? 180.0 : 260.0,
          child: ListView(
            padding: EdgeInsets.only(
                top: 0.0, bottom: MediaQuery.of(context).padding.bottom),
            children: <Widget>[
              if (widget.file.initVector == null &&
                  !offline &&
                  !BuildProperty.secureSharingEnable)
                PublicLinkSwitch(
                  file: widget.file,
                  filesState: widget.filesState,
                  filesPageState: widget.filesPageState,
                ),
              if (!widget.file.isFolder && !offline) Divider(height: 0),
              if (!widget.file.isFolder)
                ListTile(
                  onTap: () => onItemSelected(
                      FileOptionsBottomSheetResult.toggleOffline),
                  leading: Icon(Icons.airplanemode_active),
                  title: Text(s.offline),
                  trailing: Switch.adaptive(
                    value: widget.file.localId != null,
                    activeColor: Theme.of(context).accentColor,
                    onChanged: (bool val) => onItemSelected(
                        FileOptionsBottomSheetResult.toggleOffline),
                  ),
                ),
              Divider(height: 0),
              if (!offline)
                ListTile(
                  leading: Icon(widget.file.isFolder
                      ? MdiIcons.folderMove
                      : MdiIcons.fileMove),
                  title: Text(s.copy_or_move),
                  onTap: () {
                    widget.filesState.updateFilesCb =
                        widget.filesPageState.onGetFiles;
                    widget.filesState
                        .enableMoveMode(filesToMove: [widget.file]);
                    Navigator.pop(context);
                  },
                ),
              if (!offline && BuildProperty.secureSharingEnable)
                ListTile(
                  leading: AssetIcon(
                    "lib/assets/svg/insert_link.svg",
                    addedSize: 14,
                  ),
                  title: Text(s.secure_sharing),
                  onTap: _secureSharing,
                ),
              if (!offline && widget.file.type != "shared")
                ListTile(
                  leading: Icon(PlatformOverride.isIOS
                      ? MdiIcons.exportVariant
                      : Icons.share),
                  title: Text(s.btn_share_to_email),
                  onTap: () => AMDialog.show(
                    context: context,
                    builder: (_) => ShareToEmailDialog(
                      widget.filesState,
                      widget.file,
                      context,
                    ),
                  ),
                ),
              if (!widget.file.isFolder)
                ListTile(
                  leading: Icon(PlatformOverride.isIOS
                      ? MdiIcons.exportVariant
                      : Icons.share),
                  title: Text(s.share),
                  onTap: _shareFile,
                ),
              if (!PlatformOverride.isIOS && !widget.file.isFolder)
                ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text(s.download),
                  onTap: () =>
                      onItemSelected(FileOptionsBottomSheetResult.download),
                ),
              if (!offline)
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text(s.rename),
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await AMDialog.show(
                      context: context,
                      builder: (_) => RenameDialog(
                        file: widget.file,
                        filesState: widget.filesState,
                        filesPageState: widget.filesPageState,
                      ),
                    );
                    if (result is String) {
                      widget.filesPageState.onGetFiles();
                    }
                  },
                ),
              if (!offline)
                ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text(s.delete),
                  onTap: () async {
                    Navigator.pop(context);
                    final shouldDelete = await AMDialog.show<bool>(
                      context: context,
                      builder: (_) => DeleteConfirmationDialog(itemsNumber: 1),
                    );
                    if (shouldDelete == true) {
                      widget.filesPageState.onDeleteFiles(
                        storage: widget.filesState.selectedStorage,
                        filesToDelete: [widget.file],
                        onSuccess: () => widget.filesPageState.onGetFiles(),
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

  _secureSharing() async {
    if (widget.file.published == false &&
        widget.file.encryptedDecryptionKey != null) {
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
}
