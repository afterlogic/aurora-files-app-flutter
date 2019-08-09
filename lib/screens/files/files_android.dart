import 'package:aurorafiles/screens/files/components/file.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'components/folder.dart';

class FilesAndroid extends StatefulWidget {
  @override
  _FilesAndroidState createState() => _FilesAndroidState();
}

class _FilesAndroidState extends State<FilesAndroid> {
  final _filesState = FilesState();

  @override
  void initState() {
    super.initState();
    _filesState.onGetFiles();
  }

  @override
  void dispose() {
    _filesState.dispose();
    super.dispose();
  }

  Widget _buildFiles(BuildContext context, FilesState filesState) {
    if (filesState.isFilesLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (filesState.currentFiles == null ||
        filesState.currentFiles.length <= 0) {
      return Center(child: Text("No files"));
    } else {
      return ListView.builder(
        itemCount: filesState.currentFiles.length,
        itemBuilder: (BuildContext context, int index) {
          final item = filesState.currentFiles[index];
          if (item["IsFolder"]) {
            return FolderWidget(folder: item);
          } else {
            return FileWidget(file: item);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<FilesState>(
      builder: (_) => _filesState,
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Files"),
              SizedBox(height: 2),
              Text("personal",
                  style: TextStyle(fontSize: 10.0, color: Colors.white))
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Observer(builder: (_) {
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
//                height: double.minPositive,
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_filesState.currentPath == ""
                      ? "/"
                      : _filesState.currentPath),
                ),
              ),
              if (_filesState.currentPath != "")
                ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text("Level Up"),
                  onTap: _filesState.onLevelUp,
                ),
              Expanded(child: _buildFiles(context, _filesState)),
            ],
          );
        }),
      ),
    );
  }
}
