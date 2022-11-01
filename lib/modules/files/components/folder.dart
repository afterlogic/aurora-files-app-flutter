import 'dart:convert';

import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/share_access_right.dart';
import 'package:aurorafiles/modules/files/dialogs/file_options_bottom_sheet.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../files_route.dart';
import 'files_item_tile.dart';

class FolderWidget extends StatefulWidget {
  final LocalFile folder;

  const FolderWidget({Key? key, required this.folder}) : super(key: key);

  @override
  _FolderWidgetState createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  late FilesState _filesState;
  late FilesPageState _filesPageState;
  Map<String, dynamic> _extendedProps = {};
  ShareAccessRight? _sharedWithMeAccess;

  bool get _sharedWithMe => _sharedWithMeAccess != null;

  bool get _canShared =>
      _sharedWithMeAccess == null ||
      _sharedWithMeAccess == ShareAccessRight.readWriteReshare;

  @override
  void initState() {
    super.initState();
    _filesState = Provider.of<FilesState>(context, listen: false);
    _filesPageState = Provider.of<FilesPageState>(context, listen: false);
    _initExtendedProps();
    _initShareProps();
  }

  void _initExtendedProps() {
    if (widget.folder.extendedProps.isNotEmpty) {
      try {
        _extendedProps = jsonDecode(widget.folder.extendedProps);
      } catch (err) {
        print('extendedProps decode ERROR: $err');
      }
    }
  }

  void _initShareProps() {
    // if (_extendedProps.containsKey("Shares")) {
    //   final list = _extendedProps["Shares"] as List;
    // }
    if (_extendedProps.containsKey("SharedWithMeAccess")) {
      final code = _extendedProps["SharedWithMeAccess"] as int;
      _sharedWithMeAccess = ShareAccessRightHelper.fromCode(code);
    }
  }

  Future _showModalBottomSheet(
      context, FilesState filesState, FilesPageState filesPageState) async {
    FileOptionsBottomSheet.show(
      context: context,
      file: widget.folder,
      filesState: filesState,
      filesPageState: filesPageState,
      canShare: _canShared,
      sharedWithMe: _sharedWithMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    const margin = 5.0;
    final s = context.l10n;
    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: widget.folder,
        isSelected: _filesPageState.selectedFilesIds[widget.folder.id] != null,
        onTap: () {
          AuroraSnackBar.hideSnack();
          Navigator.pushNamed(
            context,
            FilesRoute.name,
            arguments: FilesScreenArguments(
              path: widget.folder.fullPath,
              isZip: _filesPageState.isInsideZip,
            ),
          );
        },
        child: Stack(children: [
          ListTile(
            leading: _getThumbnail(context),
            title: Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(widget.folder.name),
                  ),
                  if (widget.folder.published || widget.folder.localId != -1)
                    const SizedBox(height: 7.0),
                  Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(
                        color: Theme.of(context).disabledColor,
                        size: 14.0,
                      ),
                    ),
                    child: Row(children: <Widget>[
                      if (widget.folder.published)
                        Padding(
                          padding: const EdgeInsets.only(right: margin),
                          child: Icon(
                            Icons.link,
                            semanticLabel: s.has_public_link,
                          ),
                        ),
                      if (widget.folder.localId != -1)
                        Icon(
                          Icons.airplanemode_active,
                          semanticLabel: s.available_offline,
                        ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          if (!_filesState.isOfflineMode &&
              !_filesState.isMoveModeEnabled &&
              !_filesState.isShareUpload &&
              _filesPageState.selectedFilesIds.isEmpty &&
              !_filesPageState.isInsideZip)
            Positioned(
              top: 0.0,
              bottom: 0.0,
              right: 4.0,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).disabledColor,
                ),
                onPressed: () => _showModalBottomSheet(
                    context, _filesState, _filesPageState),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _getThumbnail(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.folder,
          size: _filesState.filesTileLeadingSize,
          color: _filesState.filesToMoveCopy.contains(widget.folder)
              ? Theme.of(context).disabledColor.withOpacity(0.11)
              : Theme.of(context).disabledColor,
        ),
        if (_sharedWithMe)
          Positioned(
            top: -2,
            right: -3,
            child: SvgPicture.asset(
              Asset.svg.iconSharedWithMe,
            ),
          ),
      ],
    );
  }
}
