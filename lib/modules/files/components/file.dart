import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/dialogs/file_options_bottom_sheet.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/custom_bottom_sheet.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../files_route.dart';
import 'files_item_tile.dart';

class FileWidget extends StatefulWidget {
  final LocalFile file;

  const FileWidget({Key key, @required this.file}) : super(key: key);

  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  Future _showModalBottomSheet(context) async {
    final result = await Navigator.push(
        context,
        CustomBottomSheet(
          child: FileOptionsBottomSheet(
            file: widget.file,
            filesState: Provider.of<FilesState>(context),
            filesPageState: Provider.of<FilesPageState>(context),
          ),
        ));

    switch (result) {
      case FileOptionsBottomSheetResult.toggleOffline:
        _setFileForOffline();
        break;
    }
  }

  void _openEncryptedFile(BuildContext context) {
    if (AppStore.settingsState.selectedKeyName == null) {
      showSnack(
          context: context,
          scaffoldState:
              Provider.of<FilesPageState>(context).scaffoldKey.currentState,
          msg:
              "You have enabled encryption of uploaded files but haven't set any encryption key.");
    } else {
      _openFile(context);
    }
  }

  Future _setFileForOffline() async {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    try {
      if (widget.file.localId == null) {
        showSnack(
          context: context,
          scaffoldState: filesPageState.scaffoldKey.currentState,
          msg: "Synching file...",
          isError: false,
        );
      }
      await filesState.onSetFileOffline(widget.file);
      if (widget.file.localId == null) {
        showSnack(
          context: context,
          scaffoldState: filesPageState.scaffoldKey.currentState,
          msg: "File synched successfully",
          isError: false,
        );
      }
      await filesPageState.onGetFiles();
    } catch (err) {
      showSnack(
        context: context,
        scaffoldState: filesPageState.scaffoldKey.currentState,
        msg: err.toString(),
      );
    }
  }

  void _openFile(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    // TODO enable opening ZIP files for Aurora
    if (false && widget.file.isOpenable) {
      Navigator.pushNamed(
        context,
        FilesRoute.name,
        arguments: FilesScreenArguments(
          path: widget.file.fullPath,
          isZip: true,
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        FileViewerRoute.name,
        arguments: FileViewerScreenArguments(
          file: widget.file,
          filesState: filesState,
          filesPageState: filesPageState,
        ),
      );
    }
  }

  Widget _getThumbnail(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final thumbnailSize = filesState.filesTileLeadingSize;
    final hostName = Provider.of<AuthState>(context).hostName;

    if (widget.file.initVector != null) {
      return Icon(Icons.lock_outline,
          size: thumbnailSize, color: Theme.of(context).disabledColor);
    } else if (widget.file.thumbnailUrl != null) {
      return SizedBox(
        width: thumbnailSize,
        height: thumbnailSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        AssetImage("lib/assets/images/image_placeholder.jpg"))),
            child: Hero(
              tag: widget.file.guid,
              child: filesState.isOfflineMode && widget.file.localPath != null
                  ? Image.file(new File(widget.file.localPath),
                      fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: '$hostName/${widget.file.thumbnailUrl}',
                      httpHeaders: getHeader(),
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 200),
                    ),
            ),
          ),
        ),
      );
    }

    switch (getFileType(widget.file)) {
      case FileType.text:
        return Icon(MdiIcons.fileDocumentOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.code:
        return Icon(MdiIcons.fileCode,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.pdf:
        return Icon(MdiIcons.filePdfOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.zip:
        return Icon(MdiIcons.zipBoxOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.image:
        return Icon(MdiIcons.fileImageOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.unknown:
        return Icon(MdiIcons.fileOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      default:
        return Icon(MdiIcons.fileOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    final margin = 5.0;

    return Observer(
      builder: (_) {
        final isMenuVisible = !filesState.isMoveModeEnabled &&
            !filesState.isOfflineMode &&
            filesPageState.selectedFilesIds.length <= 0 &&
            !filesPageState.isInsideZip;
        return SelectableFilesItemTile(
          file: widget.file,
          onTap: () {
            filesPageState.scaffoldKey.currentState.hideCurrentSnackBar();
            widget.file.initVector != null
                ? _openEncryptedFile(context)
                : _openFile(context);
          },
          isSelected: filesPageState.selectedFilesIds.contains(widget.file.id),
          child: Stack(children: [
            ListTile(
              leading: _getThumbnail(context),
              title: Padding(
                padding: EdgeInsets.only(right: isMenuVisible ? 28.0 : 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(widget.file.name),
                    ),
                    SizedBox(height: 7.0),
                    Theme(
                      data: Theme.of(context).copyWith(
                        iconTheme: IconThemeData(
                          color: Theme.of(context).disabledColor,
                          size: 14.0,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          if (widget.file.published)
                            Icon(
                              Icons.link,
                              semanticLabel: "Has public link",
                            ),
                          if (widget.file.published) SizedBox(width: margin),
                          if (widget.file.localId != null)
                            Icon(
                              Icons.airplanemode_active,
                              semanticLabel: "Available offline",
                            ),
                          if (widget.file.localId != null)
                            SizedBox(width: margin),
                          Text(filesize(widget.file.size),
                              style: Theme.of(context).textTheme.caption),
                          SizedBox(width: margin),
                          Text("|", style: Theme.of(context).textTheme.caption),
                          SizedBox(width: margin),
                          Text(
                              DateFormatting.formatDateFromSeconds(
                                timestamp: widget.file.lastModified,
                              ),
                              style: Theme.of(context).textTheme.caption),
                          SizedBox(width: margin),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (isMenuVisible)
              Positioned(
                top: 0.0,
                bottom: 0.0,
                right: 4.0,
                child: IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).disabledColor,
                  ),
                  onPressed: () => _showModalBottomSheet(context),
                ),
              ),
          ]),
        );
      },
    );
  }
}
