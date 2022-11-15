import 'dart:async';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/files/dialogs/add_folder_dialog.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../files_route.dart';

class FilesAppBar extends StatefulWidget {
  final Function(BuildContext) onDeleteFiles;
  final bool isAppBar;

  const FilesAppBar({
    Key? key,
    required this.onDeleteFiles,
    this.isAppBar = true,
  }) : super(key: key);

  @override
  _FilesAppBarState createState() => _FilesAppBarState();
}

class _FilesAppBarState extends State<FilesAppBar>
    with TickerProviderStateMixin {
  late FilesState _filesState;
  late FilesPageState _filesPageState;
  late AnimationController _appBarIconAnimCtrl;
  final _searchInputCtrl = TextEditingController();
  Timer? _debounce;
  String _lastSearch = '';

  @override
  void initState() {
    super.initState();
    _appBarIconAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _appBarIconAnimCtrl.dispose();
  }

  String _getFolderName() {
    String fullPath = _filesPageState.pagePath;
    if (fullPath.endsWith("/")) {
      fullPath = fullPath.substring(0, fullPath.length - 1);
    }
    final splitPath = fullPath.split(RegExp(r"/|\$ZIP:"));
    return splitPath.last.isNotEmpty ? splitPath.last : BuildProperty.appName;
  }

  void _search() {
    FocusScope.of(context).requestFocus(FocusNode());
    _filesPageState.onGetFiles(
      searchPattern: _searchInputCtrl.text,
    );
  }

  void _onSearchTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 700),
      () {
        if (value != _lastSearch) {
          _lastSearch = value;
          _search();
        }
      },
    );
  }

  void _onCloseSearch() {
    _searchInputCtrl.text = "";
    _filesPageState.isSearchMode = false;
    _lastSearch = '';
    _filesPageState.searchResult.clear();
    _filesPageState.onGetFiles(
      showLoading: FilesLoadingType.filesHidden,
    );
  }

  void _onCloseMove() {
    _filesState.isMoveModeEnabled
        ? _filesState.disableMoveMode
        : _filesState.disableUploadShared;
  }

  AMAppBar _getAppBar(BuildContext context) {
    final s = context.l10n;
    final isTablet = LayoutConfig.of(context).isTablet;
    final theme = Theme.of(context);

    if (widget.isAppBar && isTablet) {
      return AMAppBar(
        key: const Key("default"),
        leading: _filesPageState.pagePath.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: Navigator.of(context).pop,
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PopupMenuButton<String>(
              enabled: _filesPageState.pagePath.isNotEmpty,
              onSelected: (String folder) {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(FilesRoute.name + folder),
                );
              },
              itemBuilder: _getFolderPopupMenu,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: PlatformOverride.isIOS
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: <Widget>[
                    Text(_getFolderName()),
                    if (_filesPageState.pagePath.isNotEmpty)
                      const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            if (_filesState.selectedStorage.displayName.isNotEmpty)
              const SizedBox(height: 2),
            if (_filesState.selectedStorage.displayName.isNotEmpty)
              Text(
                _filesState.selectedStorage.displayName,
                style: const TextStyle(fontSize: 10.0),
              )
          ],
        ),
      );
    }

    if (_filesPageState.selectedFilesIds.isNotEmpty) {
      return AMAppBar(
        key: const Key("select"),
        backgroundColor: widget.isAppBar ? theme.primaryColorDark : null,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _filesPageState.quitSelectMode(),
        ),
        title: Text("Selected: ${_filesPageState.selectedFilesIds.length}"),
        actions: _filesState.isOfflineMode
            ? [
//          IconButton(
//            icon: Icon(Icons.airplanemode_inactive),
//            tooltip: "Delete files from offline",
//            onPressed: () {},
//          ),
              ]
            : [
                IconButton(
                  icon: const Icon(MdiIcons.fileMove),
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
                  icon: const Icon(Icons.delete_outline),
                  tooltip: "Delete files",
                  onPressed: () => widget.onDeleteFiles(context),
                ),
              ],
      );
    } else if (_filesState.isMoveModeEnabled || _filesState.isShareUpload) {
      if (!widget.isAppBar) {
        return AMAppBar(
          key: const Key("move"),
          backgroundColor: theme.colorScheme.secondary,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onCloseMove,
          ),
          title: Text(_filesState.isMoveModeEnabled
              ? s.move_file_or_folder
              : _filesState.filesToShareUpload.length > 1
                  ? s.upload_files(
                      _filesState.filesToShareUpload.length.toString())
                  : s.upload_file),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.create_new_folder),
              tooltip: s.add_folder,
              onPressed: () => AMDialog.show(
                context: context,
                builder: (_) => AddFolderDialogAndroid(
                  filesState: _filesState,
                  filesPageState: _filesPageState,
                ),
              ),
            ),
          ],
        );
      }

      return AMAppBar(
        key: const Key("move"),
        backgroundColor: theme.colorScheme.secondary,
        leading: _filesPageState.pagePath.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: Navigator.of(context).pop,
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: _onCloseMove,
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_filesState.isMoveModeEnabled
                ? s.move_file_or_folder
                : _filesState.filesToShareUpload.length > 1
                    ? s.upload_files(
                        _filesState.filesToShareUpload.length.toString())
                    : s.upload_file),
            const SizedBox(height: 2),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                _filesState.selectedStorage.displayName +
                    _filesPageState.pagePath,
                style: const TextStyle(fontSize: 10.0),
              ),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            tooltip: s.add_folder,
            onPressed: () => AMDialog.show(
              context: context,
              builder: (_) => AddFolderDialogAndroid(
                filesState: _filesState,
                filesPageState: _filesPageState,
              ),
            ),
          ),
          if (_filesState.currentStorages.length > 1)
            PopupMenuButton<Storage>(
              icon: const Icon(Icons.storage),
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
              itemBuilder: _getStoragePopupMenu,
            )
        ],
      );
    } else if (_filesPageState.isSearchMode) {
      if (!widget.isAppBar) {
        return AMAppBar(
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _search,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _onCloseSearch,
            ),
          ],
          title: PlatformOverride.isIOS
              ? CupertinoTextField(
                  autofocus: true,
                  onSubmitted: (_) => _search(),
                  onChanged: _onSearchTextChanged,
                  controller: _searchInputCtrl,
                  placeholder: s.search,
                  style: TextStyle(color: theme.colorScheme.onBackground),
                  decoration: const BoxDecoration(),
                )
              : TextField(
                  autofocus: true,
                  onSubmitted: (_) => _search(),
                  onChanged: _onSearchTextChanged,
                  controller: _searchInputCtrl,
                  style: TextStyle(color: theme.colorScheme.onBackground),
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: s.search,
                    hintStyle: const TextStyle(color: Colors.black38),
                  ),
                ),
        );
      }

      return AMAppBar(
        key: const Key("search"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _onCloseSearch,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(s.search),
            if (_filesState.selectedStorage.displayName.isNotEmpty)
              const SizedBox(height: 2),
            if (_filesState.selectedStorage.displayName.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _filesState.selectedStorage.displayName +
                      _filesPageState.pagePath,
                  style: const TextStyle(fontSize: 10.0),
                ),
              )
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: PlatformOverride.isIOS
                ? CupertinoTextField(
                    autofocus: true,
                    onSubmitted: (_) => _search(),
                    onChanged: _onSearchTextChanged,
                    controller: _searchInputCtrl,
                    placeholder: s.search,
                    style: TextStyle(color: theme.colorScheme.onBackground),
                  )
                : TextField(
                    autofocus: true,
                    onSubmitted: (_) => _search(),
                    onChanged: _onSearchTextChanged,
                    controller: _searchInputCtrl,
                    style: TextStyle(color: theme.colorScheme.onBackground),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: s.search,
                      hintStyle: const TextStyle(color: Colors.black38),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
          ),
        ),
      );
    } else {
      if (!widget.isAppBar) {
        return AMAppBar(
          key: const Key("default"),
          leading: IconButton(
            icon: const Icon(Icons.search),
            tooltip: s.search,
            onPressed: () => _filesPageState.isSearchMode = true,
          ),
        );
      }
      return AMAppBar(
        key: const Key("default"),
        leading: !widget.isAppBar
            ? const SizedBox.shrink()
            : (_filesPageState.pagePath.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: Navigator.of(context).pop,
                  )
                : null),
        title: !widget.isAppBar
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PopupMenuButton<String>(
                    enabled: _filesPageState.pagePath.isNotEmpty,
                    onSelected: (String folder) {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(FilesRoute.name + folder),
                      );
                    },
                    itemBuilder: _getFolderPopupMenu,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: PlatformOverride.isIOS
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: <Widget>[
                          Text(_getFolderName()),
                          if (_filesPageState.pagePath.isNotEmpty)
                            const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  if (_filesState.selectedStorage.displayName.isNotEmpty)
                    const SizedBox(height: 2),
                  if (_filesState.selectedStorage.displayName.isNotEmpty)
                    Text(
                      _filesState.selectedStorage.displayName,
                      style: const TextStyle(fontSize: 10.0),
                    )
                ],
              ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: s.search,
            onPressed: () => _filesPageState.isSearchMode = true,
          ),
//          IconButton(
//            icon: Icon(Icons.menu),
//            tooltip: "Menu",
//            onPressed: _filesPageState.scaffoldKey.currentState.openDrawer,
//          ),
        ],
      );
    }
  }

  List<PopupMenuEntry<String>> _getFolderPopupMenu(BuildContext context) {
    final result = <PopupMenuEntry<String>>[];
    for (int i = 0; i < _filesState.folderNavStack.length; i++) {
      if (i == _filesState.folderNavStack.length - 1) {
        continue;
      }
      final path = _filesState.folderNavStack[i];
      PopupMenuEntry<String> menuItem;
      if (path.isNotEmpty && (path.endsWith(".zip"))) {
        menuItem = PopupMenuItem<String>(
          value: path,
          child: ListTile(
            leading: const Icon(MdiIcons.zipBoxOutline),
            title: Text(
              path.split("/").last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      } else if (path.isNotEmpty) {
        menuItem = PopupMenuItem<String>(
          value: path,
          child: ListTile(
            leading: const Icon(Icons.folder),
            title: Text(
              path.split("/").last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      } else {
        menuItem = PopupMenuItem<String>(
          value: "",
          child: ListTile(
            leading: const Icon(Icons.storage),
            title: Text(_filesState.selectedStorage.displayName),
          ),
        );
      }
      result.add(menuItem);
    }
    return result;
  }

  List<PopupMenuEntry<Storage>> _getStoragePopupMenu(BuildContext context) {
    final result = <PopupMenuEntry<Storage>>[];
    for (int i = 0; i < _filesState.currentStorages.length; i++) {
      final storage = _filesState.currentStorages[i];
      bool enable = true;
      if (_filesState.isMoveModeEnabled || _filesState.isShareUpload) {
        if (storage.type == StorageType.shared) {
          enable = false;
        }
      }
      if (_filesState.isMoveModeEnabled) {
        final copyFromEncrypted =
            StorageTypeHelper.toEnum(_filesState.filesToMoveCopy.first.type) ==
                StorageType.encrypted;
        if (copyFromEncrypted) {
          if (storage.type != StorageType.encrypted) {
            enable = false;
          }
        } else {
          if (storage.type == StorageType.encrypted) {
            enable = false;
          }
        }
      }
      if (enable) {
        result.add(PopupMenuItem<Storage>(
          enabled: storage.type != _filesState.selectedStorage.type,
          value: storage,
          child: ListTile(
            leading: const Icon(Icons.storage),
            title: Text(storage.displayName),
          ),
        ));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _filesState = Provider.of<FilesState>(context);
    _filesPageState = Provider.of<FilesPageState>(context);
    return Observer(
      builder: (_) {
        final appBar = _getAppBar(context);
        if (widget.isAppBar) {
          return appBar;
        } else {
          return ListTile(
            leading: appBar.leading,
            title: appBar.title,
            trailing: appBar.actions?.isNotEmpty == true
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: appBar.actions ?? [],
                  )
                : null,
          );
        }
      },
    );
  }
}
