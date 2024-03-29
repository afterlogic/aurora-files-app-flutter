import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/models/share_access_right.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/components/files_item_tile.dart';
import 'package:aurorafiles/modules/files/dialogs/file_options_bottom_sheet.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/shared_ui/highlighted_text.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:aurorafiles/utils/file_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class FileWidget extends StatefulWidget {
  final LocalFile file;

  const FileWidget({Key? key, required this.file}) : super(key: key);

  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  late FilesState _filesState;
  late FilesPageState _filesPageState;
  double? _progress;
  ProcessingFile? _processingFile;
  Map<String, dynamic> _extendedProps = {};
  bool _hasShares = false;
  ShareAccessRight? _sharedWithMeAccess;

  bool get _sharedWithMe => _sharedWithMeAccess != null;

  bool get _canShared =>
      _sharedWithMeAccess == null ||
      _sharedWithMeAccess == ShareAccessRight.readWriteReshare;

  @override
  void initState() {
    super.initState();
    try {
      final processingFile = AppStore.filesState.processedFiles
          .firstWhere((process) => process.guid == widget.file.guid);
      _subscribeToProgress(processingFile);
    } catch (err) {
      print(err);
    }
    _initExtendedProps();
    _initShareProps();
  }

  void _initExtendedProps() {
    if (widget.file.extendedProps.isNotEmpty) {
      try {
        _extendedProps = jsonDecode(widget.file.extendedProps);
      } catch (err) {
        print('extendedProps decode ERROR: $err');
      }
    }
  }

  void _initShareProps() {
    if (_extendedProps.containsKey("Shares")) {
      final list = _extendedProps["Shares"] as List;
      _hasShares = list.isNotEmpty;
    }
    if (_extendedProps.containsKey("SharedWithMeAccess")) {
      final code = _extendedProps["SharedWithMeAccess"] as int;
      _sharedWithMeAccess = ShareAccessRightHelper.fromCode(code);
    }
  }

  void _subscribeToProgress(ProcessingFile processingFile) {
    _processingFile = processingFile;
    processingFile.progressStream.listen(
      _updateProcess,
      onDone: () {
        _updateProcess(null);
        final type = _processingFile?.processingType;
        if (type == ProcessingType.upload || type == ProcessingType.offline) {
          _filesPageState.onGetFiles();
        }
        _filesState.deleteFromProcessing(
          _processingFile?.guid,
          deleteLocally: true,
        );
        _processingFile = null;
      },
      onError: (err, s) {
        _filesState.deleteFromProcessing(
          _processingFile?.guid,
          deleteLocally: true,
        );
        _processingFile = null;
      },
      cancelOnError: true,
    );
    _updateProcess(processingFile.currentProgress);
  }

  void _updateProcess(double? num) {
    if (mounted) setState(() => _progress = num);
  }

  Future<void> _showModalBottomSheet(BuildContext context) async {
    final result = await FileOptionsBottomSheet.show(
      context: context,
      file: widget.file,
      filesState: _filesState,
      filesPageState: _filesPageState,
      canShare: _canShared,
      sharedWithMe: _sharedWithMe,
    );

    switch (result) {
      case FileOptionsBottomSheetResult.toggleOffline:
        _setFileForOffline();
        break;
      case FileOptionsBottomSheetResult.download:
        _downloadFile();
        break;
      case FileOptionsBottomSheetResult.cantShare:
        _cantShareMessage();
        break;
      case FileOptionsBottomSheetResult.cantDownload:
        _cantDownloadMessage();
        break;
    }
  }

  void _cantDownloadMessage() {
    final s = context.l10n;
    AuroraSnackBar.showSnack(msg: s.need_an_encryption_to_download);
  }

  void _cantShareMessage() {
    final s = context.l10n;
    AuroraSnackBar.showSnack(msg: s.need_an_encryption_to_share);
  }

  void _openEncryptedFile(BuildContext context) async {
    final s = context.l10n;
    if (widget.file.encryptedDecryptionKey == null) {
      if (AppStore.settingsState.selectedKeyName == null) {
        return AuroraSnackBar.showSnack(msg: s.set_any_encryption_key);
      }
    } else {
      if (!await PgpKeyUtil.instance.hasUserKey()) {
        return AuroraSnackBar.showSnack(msg: s.set_any_encryption_key);
      }
    }
    if (!mounted) return;
    _openFile(context);
  }

  void _downloadFile() {
    final s = context.l10n;
    final filesState = _filesState;
    filesState.onDownloadFile(
      context,
      file: widget.file,
      onStart: (ProcessingFile process) {
        _subscribeToProgress(process);
        AuroraSnackBar.showSnack(
          msg: s.downloading(widget.file.name),
          isError: false,
        );
      },
      onSuccess: (File savedFile) => AuroraSnackBar.showSnack(
        msg: s.downloaded_successfully_into(widget.file.name, savedFile.path),
        isError: false,
        duration: const Duration(minutes: 10),
        action: SnackBarAction(
          label: s.oK,
          onPressed: () => AuroraSnackBar.hideSnack(),
        ),
      ),
      onError: (String err) =>
          err.isNotEmpty == true ? AuroraSnackBar.showSnack(msg: err) : null,
    );
  }

  Future _setFileForOffline() async {
    final s = context.l10n;
    final filesState = _filesState;
    final filesPageState = _filesPageState;
    try {
      if (widget.file.localId == -1) {
        AuroraSnackBar.showSnack(
          msg: s.synch_file_progress,
          isError: false,
        );
      }
      await filesState.onSetFileOffline(
        widget.file,
        context,
        onStart: _subscribeToProgress,
        onSuccess: () {
          if (widget.file.localId == -1) {
            AuroraSnackBar.showSnack(
              msg: s.synched_successfully,
              isError: false,
            );
          }
          filesPageState.onGetFiles();
        },
        onError: (err) => AuroraSnackBar.showSnack(msg: err.toString()),
      );
    } catch (err) {
      AuroraSnackBar.showSnack(msg: err.toString());
    }
  }

  void _openFile(BuildContext context) async {
    // TODO enable opening ZIP files for Aurora
    //ignore: dead_code
    if (false && widget.file.isOpenable) {
      Navigator.pushNamed(
        context,
        FilesRoute.name,
        arguments: FilesScreenArguments(
          path: widget.file.fullPath,
          isZip: true,
        ),
      );
    } else {
      final file = await Navigator.of(context).pushNamed(
        FileViewerRoute.name,
        arguments: FileViewerScreenArguments(
          file: widget.file,
          offlineFile: widget.file.localPath.isNotEmpty == true
              ? File(widget.file.localPath)
              : null,
          filesState: _filesState,
          filesPageState: _filesPageState,
        ),
      );
      if (file != null && file is LocalFile) {
        for (var i = 0; i < _filesPageState.currentFiles.length; i++) {
          if (_filesPageState.currentFiles[i].id == widget.file.id) {
            _filesPageState.currentFiles[i] = file;
            break;
          }
        }
      }
    }
  }

  Widget _getThumbnail(BuildContext context) {
    final filesState = _filesState;
    final thumbnailSize = filesState.filesTileLeadingSize;
    final hostName = Provider.of<AuthState>(context).hostName;

    Widget result;
    if (widget.file.initVector != null) {
      result = Icon(MdiIcons.fileLockOutline,
          size: thumbnailSize, color: Theme.of(context).disabledColor);
    } else if (widget.file.thumbnailUrl != null ||
        filesState.isOfflineMode &&
            getFileType(widget.file) == FileType.image) {
      result = SizedBox(
        width: thumbnailSize,
        height: thumbnailSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(Asset.images.imagePlaceholder))),
            child: Hero(
              tag: FileUtils.getHeroTag(widget.file),
              child: filesState.isOfflineMode &&
                      widget.file.localPath.isNotEmpty
                  ? Image.file(File(widget.file.localPath), fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: '$hostName/${widget.file.thumbnailUrl}',
                      httpHeaders: getHeader(),
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 200),
                    ),
            ),
          ),
        ),
      );
    } else {
      switch (getFileType(widget.file)) {
        case FileType.text:
          result = Icon(MdiIcons.fileDocumentOutline,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.code:
          result = Icon(MdiIcons.fileCode,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.pdf:
          result = Icon(MdiIcons.filePdfBox,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.zip:
          result = Icon(MdiIcons.zipBoxOutline,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.image:
          result = Icon(MdiIcons.fileImageOutline,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.svg:
          result = Icon(MdiIcons.fileImageOutline,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
          break;
        case FileType.unknown:
          result = Icon(MdiIcons.fileOutline,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
          break;
        default:
          result = Icon(MdiIcons.fileOutline,
              size: thumbnailSize, color: Theme.of(context).disabledColor);
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        result,
        if (_sharedWithMe)
          Positioned(
            top: -2,
            right: -3,
            child: SvgPicture.asset(
              Asset.svg.iconSharedWithMe,
            ),
          ),
      ],
    );
  }

  IconData _getProcessIcon() {
    switch (_processingFile?.processingType) {
      case ProcessingType.upload:
        return Icons.file_upload;
      case ProcessingType.download:
      case ProcessingType.cacheImage:
      case ProcessingType.cacheToDelete:
        return Icons.file_download;
      case ProcessingType.share:
        return Icons.share;
      case ProcessingType.offline:
        return Icons.airplanemode_active;
      default:
        return Icons.close;
    }
  }

  void _onItemTap(BuildContext context) {
    AuroraSnackBar.hideSnack();
    widget.file.initVector != null
        ? _openEncryptedFile(context)
        : _openFile(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    _filesState = Provider.of<FilesState>(context);
    _filesPageState = Provider.of<FilesPageState>(context);

    const margin = 5.0;
    return Observer(
      builder: (_) {
        final isMenuVisible = !_filesState.isMoveModeEnabled &&
            !_filesState.isShareUpload &&
            _filesPageState.selectedFilesIds.isEmpty &&
            !_filesPageState.isInsideZip;
        return SelectableFilesItemTile(
          file: widget.file,
          onTap: () => _onItemTap(context),
          isSelected: _filesPageState.selectedFilesIds[widget.file.id] != null,
          child: Stack(children: [
            ListTile(
              leading: _getThumbnail(context),
              title: Padding(
                padding: EdgeInsets.only(right: isMenuVisible ? 28.0 : 0.0),
                child: LayoutBuilder(
                  builder: (context, size) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          HighlightedText(
                            text: widget.file.name,
                            highlightedPart: _filesPageState.searchText?.trim(),
                          ),
                          const SizedBox(height: 7.0),
                          Theme(
                            data: Theme.of(context).copyWith(
                              iconTheme: IconThemeData(
                                color: Theme.of(context).disabledColor,
                                size: 14.0,
                              ),
                            ),
                            child: _progress != null ||
                                    _processingFile?.processingType ==
                                        ProcessingType.upload
                                ? SizedBox(
                                    width: size.maxWidth,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(_getProcessIcon()),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          flex: 18,
                                          child: SizedBox(
                                            height: 2.0,
                                            child: LinearProgressIndicator(
                                              value: _processingFile
                                                          ?.processingType ==
                                                      ProcessingType.upload
                                                  ? null
                                                  : _progress,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (_hasShares)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: margin),
                                          child: Icon(
                                            Icons.share,
                                            semanticLabel:
                                                s.label_share_with_teammates,
                                          ),
                                        ),
                                      if (widget.file.published)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: margin),
                                          child: Icon(
                                            Icons.link,
                                            semanticLabel: s.has_public_link,
                                          ),
                                        ),
                                      if (widget.file.localId != -1)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: margin),
                                          child: Icon(
                                            Icons.airplanemode_active,
                                            semanticLabel: s.available_offline,
                                          ),
                                        ),
                                      Text(filesize(widget.file.size),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      const SizedBox(width: margin),
                                      Text("|",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      const SizedBox(width: margin),
                                      Text(
                                          DateFormatting.formatDateFromSeconds(
                                            timestamp: widget.file.lastModified,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      const SizedBox(width: margin),
                                    ],
                                  ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            if (isMenuVisible)
              Positioned(
                top: 0.0,
                bottom: 0.0,
                right: 4.0,
                child: _progress != null
                    ? _processingFile?.processingType ==
                            ProcessingType
                                .upload // TODO VO: Implement upload cancelling
                        ? const SizedBox()
                        : IconButton(
                            icon: const Icon(Icons.cancel),
                            color: Theme.of(context).disabledColor,
                            iconSize: 22.0,
                            onPressed: () {
                              _filesState.deleteFromProcessing(
                                  _processingFile?.guid,
                                  deleteLocally: true);
                            },
                          )
                    : IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).disabledColor,
                        ),
                        onPressed: () => _showModalBottomSheet(context),
                      ),
              ),
          ]),
        );
      },
    );
  }
}
