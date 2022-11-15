import 'dart:async';
import 'dart:io';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/components/founded_files_list.dart';
import 'package:aurorafiles/modules/files/components/upload_options.dart';
import 'package:aurorafiles/modules/files/dialogs/encrypt_ask_dialog.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/custom_speed_dial.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'components/files_app_bar.dart';
import 'components/files_list.dart';
import 'components/move_options.dart';
import 'components/skeleton_loader.dart';
import 'dialogs/add_folder_dialog.dart';
import 'dialogs/delete_confirmation_dialog.dart';
import 'files_route.dart';
import 'state/files_page_state.dart';
import 'package:aurorafiles/shared_ui/layout_config.dart';

class FilesAndroid extends StatefulWidget {
  final String path;
  final bool isZip;

  const FilesAndroid({
    Key? key,
    this.path = "",
    this.isZip = false,
  }) : super(key: key);

  @override
  _FilesAndroidState createState() => _FilesAndroidState();
}

class _FilesAndroidState extends State<FilesAndroid>
    with TickerProviderStateMixin {
  FilesState _filesState = AppStore.filesState;
  late FilesPageState _filesPageState;
  late SettingsState _settingsState;
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    _filesState.folderNavStack.add(widget.path);
    _settingsState = AppStore.settingsState;
    _initFiles();
    listenShare();
    sub = Connectivity().onConnectivityChanged.listen((res) async {
      if (!_filesState.isOfflineMode && res != ConnectivityResult.none) {
        if (_filesState.currentStorages.isEmpty) {
          _filesPageState.filesLoading = FilesLoadingType.filesHidden;
          await _filesState.onGetStorages(
            onError: (String err) => AuroraSnackBar.showSnack(msg: err),
          );
        }
        if (!mounted) return;
        _getFiles(
            context,
            _filesPageState.currentFiles.isEmpty
                ? FilesLoadingType.filesHidden
                : FilesLoadingType.filesVisible);
      }
    });
  }

  void listenShare() {
    // For sharing files coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {
      if (files.isEmpty) return;
      ReceiveSharingIntent.reset();
      Navigator.popUntil(
          context, (item) => item.settings.name == FilesRoute.name);
      _filesState.onUploadShared(files);
    });

    // For sharing files coming from outside the app while the app is in the memory
    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> files) {
      if (files.isNotEmpty) {
        Navigator.popUntil(
            context, (item) => item.settings.name == FilesRoute.name);
        _filesState.onUploadShared(files);
      }
    }, onError: (err) {
      print("getMediaStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? text) {
      if (text == null) return;
      ReceiveSharingIntent.reset();
      Navigator.popUntil(
          context, (item) => item.settings.name == FilesRoute.name);
      final textFile =
          SharedMediaFile('text', text, null, SharedMediaType.FILE);
      _filesState.onUploadShared([textFile]);
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    ReceiveSharingIntent.getTextStream().listen((String text) {
      Navigator.popUntil(
          context, (item) => item.settings.name == FilesRoute.name);
      final textFile =
          SharedMediaFile('text', text, null, SharedMediaType.FILE);
      _filesState.onUploadShared([textFile]);
    }, onError: (err) {
      print("getTextStream error: $err");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filesState.folderNavStack.removeLast();
    sub.cancel();
  }

  Future<void> _initFiles() async {
    _filesState = AppStore.filesState;
    _filesPageState = FilesPageState();
    _filesPageState.pagePath = widget.path;
    _filesPageState.isInsideZip = widget.isZip;

    if (_filesState.currentStorages.isEmpty) {
      _filesPageState.filesLoading = FilesLoadingType.filesHidden;
      await _filesState.onGetStorages(
        onError: (String err) => AuroraSnackBar.showSnack(msg: err),
      );
    }
    if (!mounted) return;
    _getFiles(context, FilesLoadingType.filesHidden);
    if (!_filesState.isMoveModeEnabled) {
      _filesState.updateFilesCb = _filesPageState.onGetFiles;
    }
  }

  Future<void> _getFiles(BuildContext context,
      [FilesLoadingType showLoading = FilesLoadingType.filesVisible]) async {
    return _filesPageState.onGetFiles(
      showLoading: showLoading,
      searchPattern: _filesPageState.searchText,
      onError: (String err) => AuroraSnackBar.showSnack(msg: err),
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
    final shouldDelete = await AMDialog.show(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        itemsNumber: _filesPageState.selectedFilesIds.length,
        isFolder: _filesPageState.selectedFilesIds.length == 1
            ? _filesPageState.selectedFilesIds.values.first.isFolder
            : false,
      ),
    );

    if (shouldDelete == true) {
      _filesPageState.onDeleteFiles(
        storage: _filesState.selectedStorage,
        onSuccess: () {
          _filesPageState.quitSelectMode();
          _getFiles(context);
        },
        onError: (String err) => AuroraSnackBar.showSnack(msg: err),
      );
    }
  }

  void _uploadFile() async {
    final s = context.l10n;
    _filesState.onUploadFile(
      context,
      (file) async {
        final encryptionSettings = await _settingsState.getEncryptionSetting();
        bool shouldEncrypt = false;
        if (encryptionSettings.enable) {
          shouldEncrypt =
              _filesState.selectedStorage.type == StorageType.encrypted;
        }
        if (encryptionSettings.enableInPersonalStorage &&
            _filesState.selectedStorage.type == StorageType.personal) {
          shouldEncrypt = await AMDialog.show<bool?>(
                context: context,
                builder: (_) => EncryptAskDialog(
                    file.path.split(Platform.pathSeparator).last),
              ) ??
              false;
        }
        if (shouldEncrypt == true &&
            !(await PgpKeyUtil.instance.hasUserKey())) {
          if (!mounted) return null;
          AuroraSnackBar.showSnack(
            msg: s.error_pgp_required_key(AppStore.authState.userEmail ?? ''),
          );
          return null;
        }
        return shouldEncrypt;
      },
      path: widget.path,
      onUploadStart: _addUploadingFileToFiles,
      onSuccess: () => AuroraSnackBar.showSnack(
        msg: s.successfully_uploaded,
        isError: false,
      ),
      onError: (String err) => AuroraSnackBar.showSnack(msg: err),
    );
  }

  void _addUploadingFileToFiles(ProcessingFile process) {
    _filesPageState.filesLoading = FilesLoadingType.filesVisible;
    final fakeLocalFile =
        getFakeLocalFileForUploadProgress(process, widget.path);
    _filesPageState.currentFiles.add(fakeLocalFile);
    _filesPageState.filesLoading = FilesLoadingType.none;
  }

  Widget _buildFiles(BuildContext context) {
    final s = context.l10n;
    if (_filesPageState.filesLoading == FilesLoadingType.filesHidden) {
      return ListView.separated(
        itemBuilder: (_, index) => const SkeletonLoader(),
        itemCount: 6,
        separatorBuilder: (BuildContext context, int index) => const Padding(
          padding: EdgeInsets.only(left: 80.0, right: 16.0),
          child: Divider(height: 0.0),
        ),
      );
    } else if (!_filesState.isOfflineMode &&
        _settingsState.internetConnection == ConnectivityResult.none &&
        _filesPageState.currentFiles.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.signal_wifi_off, size: 48.0),
          Text(s.no_internet_connection),
          const SizedBox(height: 16.0),
          TextButton(
            child: Text(s.retry),
            onPressed: () => _getFiles(context),
          ),
          TextButton(
            child: Text(s.go_offline),
            onPressed: () => _goOffline(),
          ),
        ],
      );
    } else if (_filesPageState.currentFiles.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
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
      return _filesPageState.isSearchMode
          ? FoundedFilesList(fileGroups: _filesPageState.searchResult)
          : FilesList(files: _filesPageState.currentFiles);
    }
  }

  Future<void> _refreshFilesList() async {
    if (_filesState.currentStorages.isEmpty) {
      await _filesState.onGetStorages();
    }
    if (!mounted) return;
    _getFiles(context, FilesLoadingType.none);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = LayoutConfig.of(context).isTablet;

    Widget body = Observer(
      builder: (_) => RefreshIndicator(
        onRefresh: _refreshFilesList,
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
                duration: const Duration(milliseconds: 150),
                opacity: _filesPageState.filesLoading ==
                        FilesLoadingType.filesVisible
                    ? 1.0
                    : 0.0,
                child: LinearProgressIndicator(
                    backgroundColor:
                        Theme.of(context).disabledColor.withOpacity(0.1)),
              ),
            ),
            if (_filesState.isShareUpload)
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: UploadOptions(
                  filesState: _filesState,
                  filesPageState: _filesPageState,
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
      ),
    );
    if (isTablet) {
      body = Row(
        children: [
          const ClipRRect(
            child: SizedBox(
              width: 304,
              child: Scaffold(
                body: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                      border: Border(right: BorderSide(width: 0.2))),
                  child: MainDrawer(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                FilesAppBar(
                  onDeleteFiles: _deleteSelected,
                  isAppBar: false,
                ),
                const Divider(height: 1),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      );
    }
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
          onWillPop: !PlatformOverride.isIOS
              ? null
              : () async => !Navigator.of(context).userGestureInProgress,
          child: Scaffold(
            key: _filesPageState.scaffoldKey,
            drawer: (_filesState.isMoveModeEnabled ||
                    _filesState.isShareUpload ||
                    isTablet)
                ? null
                : const MainDrawer(),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight *
                    (_filesPageState.isSearchMode &&
                            !_filesState.isMoveModeEnabled &&
                            !_filesState.isShareUpload &&
                            _filesPageState.selectedFilesIds.isEmpty &&
                            !isTablet
                        ? 2
                        : 1)),
                child: FilesAppBar(
                  onDeleteFiles: _deleteSelected,
                )),
            body: body,
            floatingActionButton: Observer(
              builder: (_) => _filesState.isShareUpload ||
                      _filesState.isMoveModeEnabled ||
                      _filesState.isOfflineMode ||
                      (_settingsState.internetConnection ==
                              ConnectivityResult.none &&
                          _filesPageState.currentFiles.isEmpty) ||
                      _filesPageState.isSearchMode ||
                      _filesState.selectedStorage.type == StorageType.shared ||
                      _filesPageState.isInsideZip
                  ? const SizedBox()
                  : FloatingActionButton(
                      heroTag: widget.path,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        AuroraSnackBar.hideSnack();
                        Navigator.push(
                            context,
                            CustomSpeedDial(tag: widget.path, children: [
                              MiniFab(
                                icon: const Icon(Icons.create_new_folder),
                                onPressed: () => AMDialog.show(
                                  context: context,
                                  builder: (_) => AddFolderDialogAndroid(
                                    filesState: _filesState,
                                    filesPageState: _filesPageState,
                                  ),
                                ),
                              ),
                              MiniFab(
                                  icon: const Icon(MdiIcons.filePlus),
                                  onPressed: _uploadFile),
                            ]));
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
