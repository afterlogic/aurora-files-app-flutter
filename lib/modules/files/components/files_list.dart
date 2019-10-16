import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:flutter/material.dart';

import 'file.dart';
import 'folder.dart';

class FilesList extends StatefulWidget {
  const FilesList({
    Key key,
    @required FilesPageState filesPageState,
  })  : _filesPageState = filesPageState,
        super(key: key);

  final FilesPageState _filesPageState;

  @override
  _FilesListState createState() => _FilesListState();
}

class _FilesListState extends State<FilesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 70.0),
      itemCount: widget._filesPageState.currentFiles.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget._filesPageState.currentFiles.isEmpty) return SizedBox();
        final item = widget._filesPageState.currentFiles[index];
        if (item == null) {
          return SizedBox();
        } else if (item.isFolder) {
          return FolderWidget(key: Key(item.guid), folder: item);
        } else {
          return FileWidget(key: Key(item.guid), file: item);
        }
      },
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.only(left: 80.0, right: 16.0),
        child: Divider(height: 0.0),
      ),
    );
  }
}
