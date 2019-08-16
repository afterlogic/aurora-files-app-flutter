import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'files_item_tile.dart';

class FolderWidget extends StatelessWidget {
  final File folder;

  const FolderWidget({Key key, @required this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    return Observer(
      builder: (_) => SelectableFilesItemTile(
        file: folder,
        isSelected: filesState.selectedFilesIds.contains(folder.id),
        onTap: () => filesState.onGetFiles(path: folder.fullPath, showLoading: true),
        child: ListTile(
          leading: Icon(
            Icons.folder,
            size: filesState.filesTileLeadingSize,
            color: Theme.of(context).accentColor,
          ),
          title: Text(folder.name),
        ),
      ),
    );
  }
}
