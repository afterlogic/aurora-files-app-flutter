import 'package:aurorafiles/database/app_database.dart';
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

  Future _showModalBottomSheet(context) async {
    Navigator.of(context).push(CustomBottomSheet(
      child: FileOptionsBottomSheet(
        file: folder,
        filesState: Provider.of<FilesState>(context),
        filesPageState: Provider.of<FilesPageState>(context),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    final margin = 5.0;

    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: folder,
        isSelected: filesPageState.selectedFilesIds.contains(folder.id),
        onTap: () {
          Navigator.pushNamed(
            context,
            FilesRoute.name,
            arguments: FilesScreenArguments(
              path: folder.fullPath,
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
                  Text(folder.name, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                          semanticLabel: "Has public link",
                        ),
                      if (folder.published) SizedBox(width: margin),
                      if (folder.localId != null)
                        Icon(
                          Icons.airplanemode_active,
                          semanticLabel: "Available offline",
                        ),
                    ]),
                  ),
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