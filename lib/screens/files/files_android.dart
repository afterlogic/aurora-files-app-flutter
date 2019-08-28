import 'package:aurorafiles/screens/files/components/file.dart';
import 'package:aurorafiles/screens/files/components/files_app_bar.dart';
import 'package:aurorafiles/screens/files/dialogs_android/delete_confirmation_dialog.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/custom_speed_dial.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'components/folder.dart';
import 'components/move_options.dart';
import 'components/skeleton_loader.dart';
import 'dialogs_android/add_folder_dialog_android.dart';
import 'state/files_page_state.dart';

class FilesAndroid extends StatefulWidget {
  final FilesState filesState;
  final String path;

  FilesAndroid({
    Key key,
    this.filesState,
    this.path = "",
  }) : super(key: key);

  @override
  _FilesAndroidState createState() => _FilesAndroidState();
}

class _FilesAndroidState extends State<FilesAndroid>
    with TickerProviderStateMixin {
  FilesState _filesState;
  FilesPageState _filesPageState;

  @override
  void initState() {
    super.initState();
    _initFiles();
  }

  Future<void> _initFiles() async {
    _filesState = widget.filesState ?? FilesState();
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
  }

  @override
  void dispose() {
    super.dispose();
    _filesState.dispose();
  }

  Future<void> _getFiles(BuildContext context,
      [FilesLoadingType showLoading = FilesLoadingType.filesVisible]) {
    return _filesPageState.onGetFiles(
      path: _filesPageState.pagePath,
      storage: _filesState.selectedStorage,
      showLoading: showLoading,
      onError: (String err) => showSnack(
        context: context,
        scaffoldState: _filesPageState.scaffoldKey.currentState,
        msg: err,
      ),
    );
  }

  void _deleteSelected(context) async {
    final bool shouldDelete = await showDialog(
        context: context,
        builder: (_) => DeleteConfirmationDialog(
            itemsNumber: _filesPageState.selectedFilesIds.length));
    if (shouldDelete != null && shouldDelete) {
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
              child: Text("Empty here"),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 70.0),
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
          dispose: (_, value) => value.dispose(),
        ),
        Provider<FilesPageState>(
          builder: (_) => _filesPageState,
          dispose: (_, value) => value.dispose(),
        ),
        Provider<GlobalKey<ScaffoldState>>(
          builder: (_) => _filesPageState.scaffoldKey,
        )
      ],
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          key: _filesPageState.scaffoldKey,
          drawer: Observer(
              builder: (_) =>
                  _filesState.isMoveModeEnabled ? null : MainDrawer()),
          appBar: FilesAppBar(onDeleteFiles: _deleteSelected),
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
                            child: LinearProgressIndicator(),
                          ),
                        ),
                        if (_filesState.isMoveModeEnabled)
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            height: 50.0,
                            child: MoveOptions(
                              filesState: _filesState,
                              filesPageState: _filesPageState,
                            ),
                          )
                      ],
                    ),
                  )),
          floatingActionButton: Observer(
            builder: (_) => _filesState.isMoveModeEnabled
                ? SizedBox()
                : FloatingActionButton(
                    heroTag: widget.path,
                    child: Icon(Icons.add),
                    onPressed: () => Navigator.push(
                        context,
                        CustomSpeedDial(tag: widget.path, children: [
                          MiniFab(
                            icon: Icon(Icons.create_new_folder),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AddFolderDialogAndroid(
                                  filesState: _filesState,
                                  filesPageState: _filesPageState,
                                ),
                              );
                            },
                          ),
                          MiniFab(
                            icon: Icon(Icons.cloud_upload),
                            onPressed: () {
                              _filesState.onUploadFile(
                                onUploadStart: () => showSnack(
                                  context: context,
                                  scaffoldState:
                                      _filesPageState.scaffoldKey.currentState,
                                  msg: "Uploading file...",
                                  isError: false,
                                ),
                                onSuccess: () {
                                  showSnack(
                                    context: context,
                                    scaffoldState: _filesPageState
                                        .scaffoldKey.currentState,
                                    msg: "File successfully uploaded",
                                    isError: false,
                                  );
                                  _getFiles(context);
                                },
                                onError: (String err) => showSnack(
                                  context: context,
                                  scaffoldState:
                                      _filesPageState.scaffoldKey.currentState,
                                  msg: err,
                                ),
                              );
                            },
                          ),
                        ])),
                  ),
          ),
        ),
      ),
    );
  }
}
