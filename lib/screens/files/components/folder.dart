import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/dialogs_android/file_options_bottom_sheet.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'files_item_tile.dart';

class FolderWidget extends StatelessWidget {
  final File folder;

  const FolderWidget({Key key, @required this.folder}) : super(key: key);

  Future _showModalBottomSheet(context) async {
    final String result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (_) => FileOptionsBottomSheet(
        file: folder,
        filesState: Provider.of<FilesState>(context),
      ),
    );

    if (result is String) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final margin = 5.0;

    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: folder,
        isSelected: filesState.selectedFilesIds.contains(folder.id),
        onTap: () => filesState.onGetFiles(
            path: folder.fullPath, showLoading: FilesLoadingType.filesHidden),
        child: ListTile(
          leading: Icon(
            Icons.folder,
            size: filesState.filesTileLeadingSize,
            color: Theme.of(context).accentColor,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(folder.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (folder.published || folder.localId != null) SizedBox(height: 7.0),
              Row(children: <Widget>[
                if (folder.published)
                  Icon(
                    Icons.link,
                    size: 14,
                    semanticLabel: "Has public link",
                    color: Colors.black45,
                  ),
                if (folder.published) SizedBox(width: margin),
                if (folder.localId != null)
                  Icon(
                    Icons.airplanemode_active,
                    size: 14,
                    semanticLabel: "Available offline",
                    color: Colors.black45,
                  ),
                if (folder.localId != null) SizedBox(width: margin),
              ]),
            ],
          ),
          trailing: filesState.mode == Modes.move
              ? null
              : IconButton(
                  padding: EdgeInsets.only(left: 30.0),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.more_vert),
                  onPressed: () => _showModalBottomSheet(context),
                ),
        ),
      ),
    );
  }
}
