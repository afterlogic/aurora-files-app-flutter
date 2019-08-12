import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'files_item_tile.dart';

class FolderWidget extends StatelessWidget {
  final folder;

  const FolderWidget({Key key, @required this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    return InkWell(
      onTap: () => filesState.onGetFiles(path: folder["FullPath"]),
      child: FilesItemTile(
        child: ListTile(
          leading: Icon(Icons.folder,
              size: 48.0, color: Theme.of(context).accentColor),
          title: Text(folder["Name"]),
        ),
      ),
    );
  }
}
