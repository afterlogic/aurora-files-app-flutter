import 'package:aurorafiles/screens/files/components/file.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'components/folder.dart';
import 'components/skeleton_loader.dart';

class FilesAndroid extends StatefulWidget {
  @override
  _FilesAndroidState createState() => _FilesAndroidState();
}

class _FilesAndroidState extends State<FilesAndroid>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _filesState = FilesState();
  AnimationController _appBarIconAnimCtrl;

  @override
  void initState() {
    super.initState();
    _filesState.onGetFiles();
    _appBarIconAnimCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _appBarIconAnimCtrl.dispose();
    _filesState.dispose();
  }

  AppBar _buildAppBar(BuildContext context) {
    final bool isSelectMode = _filesState.selectedFilesIds.length > 0;
    if (isSelectMode)
      _appBarIconAnimCtrl.forward();
    else
      _appBarIconAnimCtrl.reverse();
    return AppBar(
      leading: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _appBarIconAnimCtrl,
        ),
        onPressed: isSelectMode
            ? () => _filesState.selectedFilesIds = new Set()
            : () => _scaffoldKey.currentState.openDrawer(),
      ),
      title: isSelectMode
          ? Text("Selected: ${_filesState.selectedFilesIds.length}")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Files"),
                SizedBox(height: 2),
                Observer(
                  builder: (_) => Text(_filesState.currentFilesType,
                      style: TextStyle(fontSize: 10.0, color: Colors.white)),
                )
              ],
            ),
      actions: isSelectMode
          ? <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                tooltip: "Move/Copy files",
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                tooltip: "Delete files",
                onPressed: () {},
              ),
            ]
          : <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                tooltip: "Search",
                onPressed: () {},
              ),
            ],
    );
  }

  Widget _buildFiles(BuildContext context) {
    if (_filesState.isFilesLoading) {
      return ListView.builder(
        itemBuilder: (_, index) => SkeletonLoader(),
        itemCount: 6,
      );
    } else if (_filesState.currentFiles == null ||
        _filesState.currentFiles.length <= 0) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 68.0, horizontal: 16.0),
            child: Center(
              child: Text("Empty here"),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: _filesState.currentFiles.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _filesState.currentFiles[index];
          if (item["IsFolder"]) {
            return FolderWidget(key: Key(item["Id"]), folder: item);
          } else {
            return FileWidget(key: Key(item["Id"]), file: item);
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
      child: Observer(
        builder: (_) => Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawer(),
          appBar: _buildAppBar(context),
          body: Observer(
              builder: (_) => RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Theme.of(context).primaryColor,
                    onRefresh: () =>
                        _filesState.onGetFiles(path: _filesState.currentPath),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          color: Theme.of(context).highlightColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_filesState.currentPath == ""
                                ? "/"
                                : _filesState.currentPath),
                          ),
                        ),
                        if (_filesState.currentPath != "")
                          Opacity(
                            opacity: _filesState.selectedFilesIds.length > 0 ? 0.3 : 1,
                            child: ListTile(
                              leading: Icon(Icons.arrow_upward),
                              title: Text("Level Up"),
                              onTap: _filesState.selectedFilesIds.length > 0
                                  ? null
                                  : _filesState.onLevelUp,
                            ),
                          ),
                        Expanded(
                          child: _buildFiles(context),
                        ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
