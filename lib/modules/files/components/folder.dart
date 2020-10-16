import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/files/dialogs/file_options_bottom_sheet.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../files_route.dart';
import 'files_item_tile.dart';

class FolderWidget extends StatelessWidget {
  final LocalFile folder;

  const FolderWidget({Key key, @required this.folder}) : super(key: key);

  Future _showModalBottomSheet(
      context, FilesState filesState, FilesPageState filesPageState) async {
    Navigator.of(context).push(CustomBottomSheet(
      child: FileOptionsBottomSheet(
        file: folder,
        filesState: filesState,
        filesPageState: filesPageState,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    final margin = 5.0;
    final s = Str.of(context);
    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: folder,
        isSelected: filesPageState.selectedFilesIds[folder.id] != null,
        onTap: () {
          filesPageState.scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.pushNamed(
            context,
            FilesRoute.name,
            arguments: FilesScreenArguments(
              path: folder.fullPath,
              isZip: filesPageState.isInsideZip,
            ),
          );
        },
        child: Stack(children: [
          ListTile(
            leading: Icon(
              Icons.folder,
              size: filesState.filesTileLeadingSize,
              color: filesState.filesToMoveCopy.contains(folder)
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
                    child: Text(folder.name),
                  ),
                  if (folder.published || folder.localId != null)
                    SizedBox(height: 7.0),
                  Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(
                        color: Theme.of(context).disabledColor,
                        size: 14.0,
                      ),
                    ),
                    child: Row(children: <Widget>[
                      if (folder.published)
                        Icon(
                          Icons.link,
                          semanticLabel: s.has_public_link,
                        ),
                      if (folder.published) SizedBox(width: margin),
                      if (folder.localId != null)
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
          if (!filesState.isOfflineMode &&
              !filesState.isMoveModeEnabled &&
              !filesState.isShareUpload &&
              filesPageState.selectedFilesIds.length <= 0 &&
              !filesPageState.isInsideZip)
            Positioned(
              top: 0.0,
              bottom: 0.0,
              right: 4.0,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).disabledColor,
                ),
                onPressed: () =>
                    _showModalBottomSheet(context, filesState, filesPageState),
              ),
            ),
        ]),
      ),
    );
  }
}
