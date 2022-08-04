import 'dart:convert';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/share_access_right.dart';
import 'package:aurorafiles/modules/files/dialogs/file_options_bottom_sheet.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  FilesState _filesState;
  FilesPageState _filesPageState;
  Map<String, dynamic> _extendedProps = {};
  bool _hasShares = false;
  ShareAccessRight _sharedWithMeAccess;

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
    if (widget.folder.extendedProps != null) {
      try {
        _extendedProps = jsonDecode(widget.folder.extendedProps);
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
    final margin = 5.0;
    final s = Str.of(context);
    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: widget.folder,
        isSelected: _filesPageState.selectedFilesIds[widget.folder.id] != null,
        onTap: () {
          hideSnack(context);
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
            leading: Icon(
              Icons.folder,
              size: _filesState.filesTileLeadingSize,
              color: _filesState.filesToMoveCopy.contains(widget.folder)
                  ? Theme.of(context).disabledColor.withOpacity(0.11)
                  : Theme.of(context).disabledColor,
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(widget.folder.name),
                  ),
                  if (widget.folder.published || widget.folder.localId != null)
                    SizedBox(height: 7.0),
                  Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(
                        color: Theme.of(context).disabledColor,
                        size: 14.0,
                      ),
                    ),
                    child: Row(children: <Widget>[
                      if (widget.folder.published)
                        Icon(
                          Icons.link,
                          semanticLabel: s.has_public_link,
                        ),
                      if (widget.folder.published) SizedBox(width: margin),
                      if (widget.folder.localId != null)
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
              _filesPageState.selectedFilesIds.length <= 0 &&
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
}
