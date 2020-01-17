import 'dart:async';
import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/shared_ui/custom_speed_dial.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'components/files_app_bar.dart';
import 'components/files_list.dart';
import 'components/move_options.dart';
import 'components/skeleton_loader.dart';
import 'dialogs/add_folder_dialog.dart';
import 'dialogs/delete_confirmation_dialog.dart';
import 'files_route.dart';
import 'state/files_page_state.dart';

class FilesAndroid extends StatefulWidget {
  final String path;
  final bool isZip;

  FilesAndroid({
    Key key,
    this.path = "",
    this.isZip = false,
  }) : super(key: key);

  @override
  _FilesAndroidState createState() => _FilesAndroidState();
}

class _FilesAndroidState extends State<FilesAndroid>
    with TickerProviderStateMixin {
  FilesState _filesState = AppStore.filesState;
  FilesPageState _filesPageState;
  SettingsState _settingsState;
  S s;

  @override
  void initState() {
    super.initState();
    _filesState.folderNavStack.add(widget.path);
    _settingsState = AppStore.settingsState;
    _initFiles();
    Connectivity().onConnectivityChanged.listen((res) async {
      if (!_filesState.isOfflineMode && res != ConnectivityResult.none) {
        if (_filesState.currentStorages.length <= 0) {
          _filesPageState.filesLoading = FilesLoadingType.filesHidden;
          await _filesState.onGetStorages(
            onError: (String err) => showSnack(
              context: context,
              scaffoldState: _filesPageState.scaffoldKey.currentState,
              msg: err,
            ),
          );
        }
        _getFiles(
            context,
            _filesPageState.currentFiles.isEmpty
                ? FilesLoadingType.filesHidden
                : FilesLoadingType.filesVisible);
      }
    });

    _settingsState.setAppTheme(context);
  }

  @override
  void dispose() {
    super.dispose();
    _filesState.folderNavStack.removeLast();
  }

  Future<void> _initFiles() async {
    _filesState = AppStore.filesState;
    _filesPageState = FilesPageState();
    _filesPageState.pagePath = widget.path;
    _filesPageState.isInsideZip = widget.isZip;

    if (_filesState.currentStorages.length <= 0) {
      _filesPageState.filesLoading = FilesLoadingType.filesHidden;
      await _filesState.onGetStorages(
        onError: (String err) => showSnack(
          context: context,
          scaffoldState: _filesPageState.scaffoldKey.currentState,
          msg: err,
        ),
      );
    }
    if (_filesState.selectedStorage != null) {
      _getFiles(context, FilesLoadingType.filesHidden);
    }
    if (!_filesState.isMoveModeEnabled) {
      _filesState.updateFilesCb = _filesPageState.onGetFiles;
    }
  }

  Future<void> _getFiles(BuildContext context,
      [FilesLoadingType showLoading = FilesLoadingType.filesVisible]) async {
    return _filesPageState.onGetFiles(
      showLoading: showLoading,
      onError: (String err) => showSnack(
        context: context,
        scaffoldState: _filesPageState.scaffoldKey.currentState,
        msg: err,
      ),
    );
  }

  void _goOffline() {
    Navigator.popUntil(
      context,
      ModalRoute.withName(FilesRoute.name),
    );
    Navigator.pushReplacementNamed(context, FilesRoute.name,
        arguments: FilesScreenArguments(path: ""));
    _filesState.toggleOffline(true);
  }

  void _deleteSelected(context) async {
    bool shouldDelete;
    if (Platform.isIOS) {
      shouldDelete = await showCupertinoDialog(
          context: context,
          builder: (_) => DeleteConfirmationDialog(
              itemsNumber: _filesPageState.selectedFilesIds.length));
    } else {
      shouldDelete = await showDialog(
          context: context,
          builder: (_) => DeleteConfirmationDialog(
              itemsNumber: _filesPageState.selectedFilesIds.length));
    }

    if (shouldDelete == true) {
      _filesPageState.onDeleteFiles(
        storage: _filesState.selectedStorage,
        onSuccess: () {
          _filesPageState.quitSelectMode();
          _getFiles(context);
        },
        onError: (String err) => showSnack(
          context: context,
          scaffoldState: _filesPageState.scaffoldKey.currentState,
          msg: err,
        ),
      );
    }
  }

  void _uploadFile() {
    if (_filesState.selectedStorage.type == "encrypted" &&
        AppStore.settingsState.currentKey == null) {
      showSnack(
        context: context,
        scaffoldState: _filesPageState.scaffoldKey.currentState,
        msg: s.need_an_encryption_to_uploading,
      );
    } else {
      _filesState.onUploadFile(
        path: widget.path,
        onUploadStart: _addUploadingFileToFiles,
        onSuccess: () => showSnack(
          context: context,
          scaffoldState: _filesPageState.scaffoldKey.currentState,
          msg: s.successfully_uploaded,
          isError: false,
        ),
        onError: (String err) => showSnack(
          context: context,
          scaffoldState: _filesPageState.scaffoldKey.currentState,
          msg: err,
        ),
      );
    }
  }

  void _addUploadingFileToFiles(ProcessingFile process) {
    _filesPageState.filesLoading = FilesLoadingType.filesVisible;
    final fakeLocalFile =
        getFakeLocalFileForUploadProgress(process, widget.path);
    _filesPageState.currentFiles.add(fakeLocalFile);
    _filesPageState.currentFiles.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    _filesPageState.filesLoading = FilesLoadingType.none;
  }

  Widget _buildFiles(BuildContext context) {
    if (_filesPageState.filesLoading == FilesLoadingType.filesHidden) {
      return ListView.separated(
        itemBuilder: (_, index) => SkeletonLoader(),
        itemCount: 6,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.only(left: 80.0, right: 16.0),
          child: Divider(height: 0.0),
        ),
      );
    } else if (!_filesState.isOfflineMode &&
        _settingsState.internetConnection == ConnectivityResult.none &&
        _filesPageState.currentFiles.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.signal_wifi_off, size: 48.0),
          Text(s.no_internet_connection),
          SizedBox(height: 16.0),
          FlatButton(
            child: Text(s.retry),
            onPressed: () => _getFiles(context),
          ),
          FlatButton(
            child: Text(s.go_offline),
            onPressed: () => _goOffline(),
          ),
        ],
      );
    } else if (_filesPageState.currentFiles == null ||
        _filesPageState.currentFiles.length <= 0) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 68.0, horizontal: 16.0),
            child: Center(
              child: Text(
                  _filesPageState.isSearchMode ? s.no_results : s.empty_here),
            ),
          ),
        ],
      );
    } else {
      return FilesList(filesPageState: _filesPageState);
    }
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    return MultiProvider(
      providers: [
        Provider<FilesState>(
          create: (_) => _filesState,
        ),
        Provider<FilesPageState>(
          create: (_) => _filesPageState,
        ),
        Provider<AuthState>(
          create: (_) => AppStore.authState,
        )
      ],
      child: Observer(
        builder: (_) => WillPopScope(
          onWillPop: !Platform.isIOS
              ? null
              : () async => !Navigator.of(context).userGestureInProgress,
          child: Scaffold(
            key: _filesPageState.scaffoldKey,
            drawer: _filesState.isMoveModeEnabled ? null : MainDrawer(),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height *
                    (_filesPageState.isSearchMode &&
                        !_filesState.isMoveModeEnabled &&
                        _filesPageState.selectedFilesIds.isEmpty
                        ? 2.3
                        : 1)),
                child: FilesAppBar(onDeleteFiles: _deleteSelected)),
            body: Observer(
                builder: (_) => RefreshIndicator(
                  onRefresh: () async {
                    if (_filesState.currentStorages.length <= 0) {
                      await _filesState.onGetStorages();
                    }
                    return _getFiles(context, FilesLoadingType.none);
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned.fill(
                        child: _buildFiles(context),
                      ),
                      // LOADER
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        height: 6.0,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 150),
                          opacity: _filesPageState.filesLoading ==
                              FilesLoadingType.filesVisible
                              ? 1.0
                              : 0.0,
                          child: LinearProgressIndicator(
                              backgroundColor: Theme
                                  .of(context)
                                  .disabledColor
                                  .withOpacity(0.1)),
                        ),
                      ),
                      if (_filesState.isMoveModeEnabled)
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: MoveOptions(
                            filesState: _filesState,
                            filesPageState: _filesPageState,
                          ),
                        )
                    ],
                  ),
                )),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Observer(
                builder: (_) => _filesState.isMoveModeEnabled ||
                    _filesState.isOfflineMode ||
                    (_settingsState.internetConnection ==
                        ConnectivityResult.none &&
                        _filesPageState.currentFiles.isEmpty) ||
                    _filesPageState.isSearchMode ||
                    _filesState.selectedStorage.type == "shared" ||
                    _filesPageState.isInsideZip
                    ? SizedBox()
                    : FloatingActionButton(
                  heroTag: widget.path,
                  child: Icon(Icons.add),
                  onPressed: () {
                    _filesPageState.scaffoldKey.currentState
                        .removeCurrentSnackBar();
                    Navigator.push(
                        context,
                        CustomSpeedDial(tag: widget.path, children: [
                          MiniFab(
                            icon: Icon(Icons.create_new_folder),
                            onPressed: () =>
                            Platform.isIOS
                                ? showCupertinoDialog(
                              context: context,
                              builder: (_) =>
                                  AddFolderDialogAndroid(
                                    filesState: _filesState,
                                    filesPageState: _filesPageState,
                                  ),
                            )
                                : showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) =>
                                  AddFolderDialogAndroid(
                                    filesState: _filesState,
                                    filesPageState: _filesPageState,
                                  ),
                            ),
                          ),
                          MiniFab(
                              icon: Icon(MdiIcons.filePlus),
                              onPressed: _uploadFile),
                        ]));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
