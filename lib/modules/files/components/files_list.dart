

import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:flutter/material.dart';

import 'file.dart';
import 'folder.dart';

class FilesList extends StatefulWidget {
  const FilesList({
    Key key,
    @required FilesPageState filesPageState,
  }) : _filesPageState = filesPageState, super(key: key);

  final FilesPageState _filesPageState;

  @override
  _FilesListState createState() => _FilesListState();
}

class _FilesListState extends State<FilesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 70.0),
      itemCount: widget._filesPageState.currentFiles.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget._filesPageState.currentFiles[index];
        if (item.isFolder) {
          return FolderWidget(key: Key(item.id), folder: item);
        } else {
          return FileWidget(key: Key(item.id), file: item);
        }
      },
    );
  }
}