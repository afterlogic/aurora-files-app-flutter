import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/files/dialogs_android/add_folder_dialog_android.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../files_route.dart';

class FilesAppBar extends StatefulWidget with PreferredSizeWidget {
  final Function(BuildContext) onDeleteFiles;

  FilesAppBar({Key key, @required this.onDeleteFiles}) : super(key: key);

  @override
  _FilesAppBarState createState() => _FilesAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class _FilesAppBarState extends State<FilesAppBar>
    with TickerProviderStateMixin {
  FilesState _filesState;
  FilesPageState _filesPageState;
  AnimationController _appBarIconAnimCtrl;
  AppBar _currentAppBar;
  final _searchInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appBarIconAnimCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _appBarIconAnimCtrl.dispose();
  }

  AppBar _getAppBar(BuildContext context) {
    if (_filesPageState.selectedFilesIds.length > 0) {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _filesPageState.quitSelectMode(),
        ),
        title: Text("Selected: ${_filesPageState.selectedFilesIds.length}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.fileMove),
            tooltip: "Move/Copy files",
            onPressed: () {
              _filesState.updateFilesCb = _filesPageState.onGetFiles;
              _filesState.enableMoveMode(
                selectedFileIds: _filesPageState.selectedFilesIds,
                currentFiles: _filesPageState.currentFiles,
              );
              _filesPageState.quitSelectMode();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            tooltip: "Delete files",
            onPressed: () => widget.onDeleteFiles(context),
          ),
        ],
      );
    } else if (_filesState.isMoveModeEnabled) {
      return AppBar(
        leading: _filesPageState.pagePath.length > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: Navigator.of(context).pop,
              )
            : IconButton(
                icon: Icon(Icons.close),
                onPressed: _filesState.disableMoveMode,
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Move files/folders"),
            SizedBox(height: 2),
            Text(
              _filesState.selectedStorage.displayName +
                  _filesPageState.pagePath,
              style: TextStyle(fontSize: 10.0),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.create_new_folder),
            tooltip: "Add folder",
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AddFolderDialogAndroid(
                filesState: _filesState,
                filesPageState: _filesPageState,
              ),
            ),
          ),
          PopupMenuButton<Storage>(
            icon: Icon(Icons.storage),
            onSelected: (Storage storage) async {
              Navigator.of(context).popUntil((Route<dynamic> route) {
                return route.isFirst;
              });
              // set new storage and reload files
              _filesState.selectedStorage = storage;
              Navigator.of(context).pushReplacementNamed(
                FilesRoute.name,
                arguments: FilesScreenArguments(
                  filesState: _filesState,
                  path: "",
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Storage>>[
              ..._filesState.currentStorages.map((Storage storage) {
                return PopupMenuItem<Storage>(
                  value: storage,
                  child: ListTile(
                    leading: Icon(Icons.storage),
                    title: Text(storage.displayName),
                  ),
                );
              }),
            ],
          )
        ],
      );
    } else {
      return AppBar(
        leading: _filesPageState.pagePath.length > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: Navigator.of(context).pop,
              )
            : Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  top: 6.0,
                  right: 6.0,
                  bottom: 6.0,
                ),
                child: Image.asset("lib/assets/images/logo_white.png"),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(SingletonStore.instance.appName),
            if (_filesState.selectedStorage.displayName.length > 0)
              SizedBox(height: 2),
            if (_filesState.selectedStorage.displayName.length > 0)
              Text(
                _filesState.selectedStorage.displayName +
                    _filesPageState.pagePath,
                style: TextStyle(fontSize: 10.0),
              )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "Search",
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: "Menu",
            onPressed: _filesPageState.scaffoldKey.currentState.openDrawer,
          ),
        ],
      );
//        return AppBar(
//          leading: IconButton(
//            icon: Icon(Icons.arrow_back),
//            color: Colors.black45,
//            onPressed: () {
//              _searchInputCtrl.text = "";
//              _filesState.disableSearchMode();
//              _filesState.onGetFiles(
//                path: _filesState.currentPath,
//                showLoading: FilesLoadingType.filesHidden,
//              );
//            },
//          ),
//          title: TextField(
//            controller: _searchInputCtrl,
//            autofocus: true,
//            decoration: InputDecoration.collapsed(
//              hintText: "Search",
//              hintStyle: TextStyle(
//                fontSize: Theme.of(context).textTheme.title.fontSize,
//                fontWeight: Theme.of(context).textTheme.title.fontWeight,
//              ),
//            ),
//            style: Theme.of(context).textTheme.title,
//          ),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.search),
//              color: Colors.black45,
//              onPressed: () => _filesState.onGetFiles(
//                path: _filesState.currentPath,
//                searchPattern: _searchInputCtrl.text,
//              ),
//            )
//          ],
//          backgroundColor: Colors.white,
//        );
    }
  }

  @override
  Widget build(BuildContext context) {
    _filesState = Provider.of<FilesState>(context);
    _filesPageState = Provider.of<FilesPageState>(context);
    _currentAppBar = _getAppBar(context);

    return Observer(
      builder: (_) {
        _currentAppBar = _getAppBar(context);

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _currentAppBar,
        );
      },
    );
  }
}
