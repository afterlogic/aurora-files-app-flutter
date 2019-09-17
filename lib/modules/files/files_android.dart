import 'dart:io';

import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/custom_speed_dial.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'components/file.dart';
import 'components/files_app_bar.dart';
import 'components/folder.dart';
import 'components/move_options.dart';
import 'components/skeleton_loader.dart';
import 'dialogs/add_folder_dialog.dart';
import 'dialogs/delete_confirmation_dialog.dart';
import 'state/files_page_state.dart';

class FilesAndroid extends StatefulWidget {
  final String path;

  FilesAndroid({
    Key key,
    this.path = "",
  }) : super(key: key);

  @override
  _FilesAndroidState createState() => _FilesAndroidState();
}

class _FilesAndroidState extends State<FilesAndroid>
    with TickerProviderStateMixin {
  FilesState _filesState = AppStore.filesState;
  FilesPageState _filesPageState;

  @override
  void initState() {
    super.initState();
    _filesState.folderNavStack.add(widget.path);
    _initFiles();
  }

  @override
  void dispose() {
    super.dispose();
    _filesState.folderNavStack.removeLast();
    _filesPageState.dispose();
  }

  Future<void> _initFiles() async {
    _filesState = AppStore.filesState;
    _filesPageState = FilesPageState();
    _filesPageState.pagePath = widget.path;

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
      [FilesLoadingType showLoading = FilesLoadingType.filesVisible]) {
    return _filesPageState.onGetFiles(
      showLoading: showLoading,
      onError: (String err) => showSnack(
        context: context,
        scaffoldState: _filesPageState.scaffoldKey.currentState,
        msg: err,
      ),
    );
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
        msg: "You need to set an encryption key before uploading files.",
      );
    } else {
      _filesState.onUploadFile(
        path: widget.path,
        onEncryptionStart: () => showSnack(
          context: context,
          scaffoldState: _filesPageState.scaffoldKey.currentState,
          msg: "Encrypting file...",
          isError: false,
        ),
        onUploadStart: () => showSnack(
          context: context,
          scaffoldState: _filesPageState.scaffoldKey.currentState,
          msg: "Uploading file...",
          isError: false,
        ),
        onSuccess: () {
          showSnack(
            context: context,
            scaffoldState: _filesPageState.scaffoldKey.currentState,
            msg: "File successfully uploaded",
            isError: false,
          );
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

  Widget _buildFiles(BuildContext context) {
    if (_filesPageState.filesLoading == FilesLoadingType.filesHidden) {
      return ListView.builder(
        itemBuilder: (_, index) => SkeletonLoader(),
        itemCount: 6,
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
                  _filesPageState.isSearchMode ? "No results" : "Empty here"),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 70.0),
        itemCount: _filesPageState.currentFiles.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _filesPageState.currentFiles[index];
          if (item.isFolder) {
            return FolderWidget(key: Key(item.id), folder: item);
          } else {
            return FileWidget(key: Key(item.id), file: item);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FilesState>(
          builder: (_) => _filesState,
        ),
        Provider<FilesPageState>(
          builder: (_) => _filesPageState,
          dispose: (_, value) => value.dispose(),
        ),
        Provider<AuthState>(
          builder: (_) => AppStore.authState,
        )
      ],
      child: Observer(
        builder: (_) => Scaffold(
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
                                backgroundColor: Theme.of(context)
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
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Observer(
              builder: (_) => _filesState.isMoveModeEnabled ||
                      _filesPageState.isSearchMode ||
                      _filesState.selectedStorage.type == "shared" ||
                _filesPageState.pagePath.contains("\$ZIP:") ||
                _filesPageState.pagePath.endsWith(".zip")
                  ? SizedBox()
                  : FloatingActionButton(
                      heroTag: widget.path,
                      child: Icon(Icons.add),
                      onPressed: () => Navigator.push(
                          context,
                          CustomSpeedDial(tag: widget.path, children: [
                            MiniFab(
                              icon: Icon(Icons.create_new_folder),
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
                            MiniFab(
                                icon: Icon(MdiIcons.filePlus),
                                onPressed: _uploadFile),
                          ])),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
