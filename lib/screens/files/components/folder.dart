import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderWidget extends StatelessWidget {
  final folder;

  const FolderWidget({Key key, @required this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    return InkWell(
      onTap: () => filesState.onGetFiles(path: folder["FullPath"]),
      child: Column(
        children: <Widget>[
          SizedBox(height: 6.0),
          ListTile(
            leading: Icon(Icons.folder,
                size: 48.0, color: Theme.of(context).accentColor),
            title: Text(folder["Name"]),
          ),
          SizedBox(height: 6.0),
          Padding(
            padding: const EdgeInsets.only(left: 80.0),
            child: Divider(height: 0.0),
          ),
        ],
      ),
    );
  }
}
