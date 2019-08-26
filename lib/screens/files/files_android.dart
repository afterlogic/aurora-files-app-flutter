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
        child: Observer(
          builder: (_) => Scaffold(
            key: _filesPageState.scaffoldKey,
            drawer: MainDrawer(),
            appBar: FilesAppBar(onDeleteFiles: _deleteSelected),
            body: Observer(
                builder: (_) => RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      onRefresh: () async {
                        if (_filesState.currentStorages.length <= 0) {
                          await _filesState.onGetStorages();
                        }
                        return _getFiles(context, FilesLoadingType.none);
                      },
                      child: Column(
                        children: <Widget>[
                          // LOADER
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 150),
                            opacity: _filesPageState.filesLoading ==
                                    FilesLoadingType.filesVisible
                                ? 1.0
                                : 0.0,
                            child: LinearProgressIndicator(),
                          ),
                          // PATH INDICATOR
//                          if (_filesState.mode != Modes.search)
//                            Container(
//                              width: double.infinity,
//                              color: Theme.of(context).highlightColor,
//                              child: Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 10.0, top: 3.0, bottom: 9.0),
//                                child: Text(_filesState.currentPath == ""
//                                    ? "/"
//                                    : _filesState.currentPath),
//                              ),
//                            ),
//                          if (_filesState.currentPath != "")
//                            Opacity(
//                              opacity: _filesState.selectedFilesIds.length > 0
//                                  ? 0.3
//                                  : 1,
//                              child: ListTile(
//                                leading: Icon(Icons.arrow_upward),
//                                title: Text("Level Up"),
//                                onTap: _filesState.selectedFilesIds.length > 0
//                                    ? null
//                                    : () => _filesState.onLevelUp(
//                                          () => _getFiles(context,
//                                              FilesLoadingType.filesHidden),
//                                        ),
//                              ),
//                            ),
                          Expanded(
                            child: _buildFiles(context),
                          ),
                        ],
                      ),
                    )),
            floatingActionButton: FloatingActionButton(
              heroTag: widget.path,
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
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
