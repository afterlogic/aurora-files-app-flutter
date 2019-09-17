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

import 'files_item_tile.dart';

class FileWidget extends StatelessWidget {
  final LocalFile file;

  const FileWidget({Key key, @required this.file}) : super(key: key);

  Future _showModalBottomSheet(context) async {
    Navigator.of(context).push(CustomBottomSheet(
      child: FileOptionsBottomSheet(
        file: file,
        filesState: Provider.of<FilesState>(context),
        filesPageState: Provider.of<FilesPageState>(context),
      ),
    ));
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

  void _openFile(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);

    Navigator.pushNamed(
      context,
      FileViewerRoute.name,
      arguments: FileViewerScreenArguments(
        file: file,
        filesState: filesState,
        filesPageState: filesPageState,
      ),
    );
  }

  Widget _getThumbnail(BuildContext context) {
    final thumbnailSize = Provider.of<FilesState>(context).filesTileLeadingSize;
    final hostName = Provider.of<AuthState>(context).hostName;

    if (file.initVector != null) {
      return Icon(Icons.lock_outline,
          size: thumbnailSize, color: Theme.of(context).disabledColor);
    } else if (file.thumbnailUrl != null) {
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
              tag: file.thumbnailUrl,
              child: CachedNetworkImage(
                imageUrl: '$hostName/${file.thumbnailUrl}',
                httpHeaders: getHeader(),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 200),
              ),
            ),
          ),
        ),
      );
    }

    switch (getFileType(file)) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    final margin = 5.0;

    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: file,
        onTap: () => file.initVector != null
            ? _openEncryptedFile(context)
            : _openFile(context),
        isSelected: filesPageState.selectedFilesIds.contains(file.id),
        child: Stack(children: [
          ListTile(
            leading: _getThumbnail(context),
            title: Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                        if (file.published)
                          Icon(
                            Icons.link,
                            semanticLabel: "Has public link",
                          ),
                        if (file.published) SizedBox(width: margin),
                        if (file.localId != null)
                          Icon(
                            Icons.airplanemode_active,
                            semanticLabel: "Available offline",
                          ),
                        if (file.localId != null) SizedBox(width: margin),
                        Text(filesize(file.size),
                            style: Theme.of(context).textTheme.caption),
                        SizedBox(width: margin),
                        Text("|", style: Theme.of(context).textTheme.caption),
                        SizedBox(width: margin),
                        Text(
                            DateFormatting.formatDateFromSeconds(
                              timestamp: file.lastModified,
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
          if (!filesState.isMoveModeEnabled &&
              filesPageState.selectedFilesIds.length <= 0)
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
      ),
    );
  }
}
