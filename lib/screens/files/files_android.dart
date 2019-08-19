import 'package:aurorafiles/screens/files/components/file.dart';
import 'package:aurorafiles/screens/files/components/files_app_bar.dart';
import 'package:aurorafiles/screens/files/dialogs_android/add_folder_dialog_android.dart';
import 'package:aurorafiles/screens/files/dialogs_android/delete_confirmation_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _getFiles(context, true);
  }

  @override
  void dispose() {
    super.dispose();
    _filesState.dispose();
  }

  Future<void> _getFiles(BuildContext context, [showLoading = false]) {
    return _filesState.onGetFiles(
      path: _filesState.currentPath,
      showLoading: showLoading,
      onError: (String err) => _showErrSnack(context, err),
    );
  }

  void _deleteSelected(context) async {
    final bool shouldDelete = await showDialog(
        context: context,
        builder: (_) => DeleteConfirmationDialog(
            itemsNumber: _filesState.selectedFilesIds.length));
    if (shouldDelete != null && shouldDelete) {
      _filesState.onDeleteFiles(
        onSuccess: () {
          _filesState.selectedFilesIds = new Set();
          _getFiles(context);
        },
        onError: (String err) => _showErrSnack(context, err),
      );
    }
  }

  void _showErrSnack(BuildContext context, String msg) {
    final snack = SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).errorColor,
    );

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snack);
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
    return Provider<FilesState>(
      builder: (_) => _filesState,
      dispose: (_, value) => value.dispose(),
      child: SafeArea(
        top: false,
        child: Observer(
          builder: (_) => Scaffold(
            key: _scaffoldKey,
            drawer: MainDrawer(),
            appBar: FilesAppBar(onDeleteFiles: _deleteSelected),
            body: Observer(
                builder: (_) => RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: Theme.of(context).primaryColor,
                      onRefresh: () => _getFiles(context),
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
                              opacity: _filesState.selectedFilesIds.length > 0
                                  ? 0.3
                                  : 1,
                              child: ListTile(
                                leading: Icon(Icons.arrow_upward),
                                title: Text("Level Up"),
                                onTap: _filesState.selectedFilesIds.length > 0
                                    ? null
                                    : () => _filesState.onLevelUp(
                                          () => _getFiles(context, true),
                                        ),
                              ),
                            ),
                          Expanded(
                            child: _buildFiles(context),
                          ),
                        ],
                      ),
                    )),
            floatingActionButton: _filesState.isMoveModeEnabled
                ? null
                : FloatingActionButton(
                    child: Icon(Icons.create_new_folder),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AddFolderDialogAndroid(
                        filesState: _filesState,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
