import 'dart:io';

import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/files/dialogs/add_folder_dialog.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../files_route.dart';

class FilesAppBar extends StatefulWidget {
  final Function(BuildContext) onDeleteFiles;

  FilesAppBar({Key key, @required this.onDeleteFiles}) : super(key: key);

  @override
  _FilesAppBarState createState() => _FilesAppBarState();
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
        centerTitle: Platform.isIOS,
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
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                onPressed: Navigator.of(context).pop,
              )
            : IconButton(
                icon: Icon(Icons.close),
                onPressed: _filesState.disableMoveMode,
              ),
        title: Column(
          crossAxisAlignment: Platform.isIOS
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
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
        centerTitle: Platform.isIOS,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.create_new_folder),
            tooltip: "Add folder",
            onPressed: () => Platform.isIOS
                ? showCupertinoDialog(
                    context: context,
                    builder: (_) => AddFolderDialogAndroid(
                      filesState: _filesState,
                      filesPageState: _filesPageState,
                    ),
                  )
                : showDialog(
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
    } else if (_filesPageState.isSearchMode) {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            _searchInputCtrl.text = "";
            _filesPageState.isSearchMode = false;
            _filesPageState.onGetFiles(
              showLoading: FilesLoadingType.filesHidden,
            );
          },
        ),
        title: Column(
          crossAxisAlignment: Platform.isIOS
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Search"),
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
        centerTitle: Platform.isIOS,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Platform.isIOS
                  ? CupertinoTextField(
                      onSubmitted: (_) => _filesPageState.onGetFiles(
                        searchPattern: _searchInputCtrl.text,
                      ),
                      autofocus: true,
                      controller: _searchInputCtrl,
                      placeholder: "Search",
                      suffix: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => _filesPageState.onGetFiles(
                          searchPattern: _searchInputCtrl.text,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Container(
                        color: Colors.white54,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 2.0),
                          child: TextField(
                            autofocus: true,
                            onSubmitted: (_) => _filesPageState.onGetFiles(
                              searchPattern: _searchInputCtrl.text,
                            ),
                            style: TextStyle(color: Colors.black),
                            controller: _searchInputCtrl,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black38),
                                hintText: "Search",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  color: Colors.black,
                                  onPressed: () => _filesPageState.onGetFiles(
                                    searchPattern: _searchInputCtrl.text,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );
    } else {
      return AppBar(
        leading: _filesPageState.pagePath.length > 0
            ? IconButton(
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
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
          crossAxisAlignment: Platform.isIOS
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("PrivateMail Files"),
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
        centerTitle: Platform.isIOS,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "Search",
            onPressed: () => _filesPageState.isSearchMode = true,
          ),
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: "Menu",
            onPressed: _filesPageState.scaffoldKey.currentState.openDrawer,
          ),
        ],
      );
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