import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/dialogs/file_options_bottom_sheet.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/custom_bottom_sheet.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../files_route.dart';
import 'files_item_tile.dart';

class FileWidget extends StatefulWidget {
  final LocalFile file;

  const FileWidget({Key key, @required this.file}) : super(key: key);

  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  FilesState _filesState;
  FilesPageState _filesPageState;
  double _progress;
  ProcessingFile _processingFile;
  S s;

  @override
  void initState() {
    super.initState();
    try {
      final processingFile = AppStore.filesState.processedFiles
          .firstWhere((process) => process.guid == widget.file.guid);
      _subscribeToProgress(processingFile);
    } catch (err) {}
  }

  void _subscribeToProgress(ProcessingFile processingFile) {
    _processingFile = processingFile;
    processingFile.progressStream.listen(
      _updateProcess,
      onDone: () {
        _updateProcess(null);
        final type = _processingFile.processingType;
        if (type == ProcessingType.upload || type == ProcessingType.offline) {
          _filesPageState.onGetFiles();
        }
        _filesState.deleteFromProcessing(_processingFile.guid,
            deleteLocally: true);
        _processingFile = null;
      },
      onError: (err, s) {
        _filesState.deleteFromProcessing(_processingFile.guid,
            deleteLocally: true);
        _processingFile = null;
      },
      cancelOnError: true,
    );
    _updateProcess(processingFile.currentProgress);
  }

  void _updateProcess(double num) {
    if (mounted) setState(() => _progress = num);
  }

  Future _showModalBottomSheet(context) async {
    final result = await Navigator.push(
        context,
        CustomBottomSheet(
          child: FileOptionsBottomSheet(
            file: widget.file,
            filesState: Provider.of<FilesState>(context),
            filesPageState: Provider.of<FilesPageState>(context),
          ),
        ));

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
    }
  }

  void _cantShareMessage() {
    final filesPageState = Provider.of<FilesPageState>(context);
    showSnack(
      context: context,
      scaffoldState: filesPageState.scaffoldKey.currentState,
      msg: s.need_an_encryption_to_share,
    );
  }

  void _openEncryptedFile(BuildContext context) {
    if (AppStore.settingsState.selectedKeyName == null) {
      showSnack(
          context: context,
          scaffoldState:
              Provider.of<FilesPageState>(context).scaffoldKey.currentState,
          msg: s.set_any_encryption_key);
    } else {
      _openFile(context);
    }
  }

  void _downloadFile() {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    filesState.onDownloadFile(
      file: widget.file,
      onStart: (ProcessingFile process) {
        _subscribeToProgress(process);
        showSnack(
          context: context,
          scaffoldState: filesPageState.scaffoldKey.currentState,
          msg: s.downloading(widget.file.name),
          isError: false,
        );
      },
      onSuccess: (File savedFile) => showSnack(
          context: context,
          scaffoldState: filesPageState.scaffoldKey.currentState,
          msg: s.downloaded_successfully_into(widget.file.name, savedFile.path),
          isError: false,
          duration: Duration(minutes: 10),
          action: SnackBarAction(
            label: s.oK,
            onPressed:
                filesPageState.scaffoldKey.currentState.hideCurrentSnackBar,
          )),
      onError: (String err) => showSnack(
        context: context,
        scaffoldState: filesPageState.scaffoldKey.currentState,
        msg: err,
      ),
    );
  }

  Future _setFileForOffline() async {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    try {
      if (widget.file.localId == null) {
        showSnack(
          context: context,
          scaffoldState: filesPageState.scaffoldKey.currentState,
          msg: s.synch_file_progress,
          isError: false,
        );
      }
      await filesState.onSetFileOffline(
        widget.file,
        onStart: _subscribeToProgress,
        onSuccess: () {
          if (widget.file.localId == null) {
            showSnack(
              context: context,
              scaffoldState: filesPageState.scaffoldKey.currentState,
              msg: s.synched_successfully,
              isError: false,
            );
          }
          filesPageState.onGetFiles();
        },
        onError: (err) => showSnack(
            context: context,
            scaffoldState: filesPageState.scaffoldKey.currentState,
            msg: err.toString()),
      );
    } catch (err, s) {
      showSnack(
        context: context,
        scaffoldState: filesPageState.scaffoldKey.currentState,
        msg: err.toString(),
      );
    }
  }

  void _openFile(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final filesPageState = Provider.of<FilesPageState>(context);
    // TODO enable opening ZIP files for Aurora
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
      Navigator.pushNamed(
        context,
        FileViewerRoute.name,
        arguments: FileViewerScreenArguments(
          file: widget.file,
          offlineFile: widget.file.localPath?.isNotEmpty == true
              ? new File(widget.file.localPath)
              : null,
          filesState: filesState,
          filesPageState: filesPageState,
        ),
      );
    }
  }

  Widget _getThumbnail(BuildContext context) {
    final filesState = Provider.of<FilesState>(context);
    final thumbnailSize = filesState.filesTileLeadingSize;
    final hostName = Provider.of<AuthState>(context).hostName;

    if (widget.file.initVector != null) {
      return Icon(MdiIcons.fileLockOutline,
          size: thumbnailSize, color: Theme.of(context).disabledColor);
    } else if (widget.file.thumbnailUrl != null ||
        filesState.isOfflineMode &&
            getFileType(widget.file) == FileType.image) {
      return SizedBox(
        width: thumbnailSize,
        height: thumbnailSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        AssetImage("lib/assets/images/image_placeholder.jpg"))),
            child: Hero(
              tag: widget.file.localId ?? widget.file.guid ?? widget.file.hash,
              child: filesState.isOfflineMode && widget.file.localPath != null
                  ? Image.file(new File(widget.file.localPath),
                      fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: '$hostName/${widget.file.thumbnailUrl}',
                      httpHeaders: getHeader(),
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 200),
                    ),
            ),
          ),
        ),
      );
    }

    switch (getFileType(widget.file)) {
      case FileType.text:
        return Icon(MdiIcons.fileDocumentOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.code:
        return Icon(MdiIcons.fileCode,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.pdf:
        return Icon(MdiIcons.filePdfOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.zip:
        return Icon(MdiIcons.zipBoxOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.image:
        return Icon(MdiIcons.fileImageOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      case FileType.unknown:
        return Icon(MdiIcons.fileOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
      default:
        return Icon(MdiIcons.fileOutline,
            size: thumbnailSize, color: Theme.of(context).disabledColor);
    }
  }

  IconData _getProcessIcon() {
    switch (_processingFile.processingType) {
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

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    _filesState = Provider.of<FilesState>(context);
    _filesPageState = Provider.of<FilesPageState>(context);
    final margin = 5.0;
    return Observer(
      builder: (_) {
        final isMenuVisible = !_filesState.isMoveModeEnabled &&
            _filesPageState.selectedFilesIds.length <= 0 &&
            !_filesPageState.isInsideZip;
        return SelectableFilesItemTile(
          file: widget.file,
          onTap: () {
            _filesPageState.scaffoldKey.currentState.hideCurrentSnackBar();
            widget.file.initVector != null
                ? _openEncryptedFile(context)
                : _openFile(context);
          },
          isSelected: _filesPageState.selectedFilesIds.contains(widget.file.id),
          child: Stack(children: [
            ListTile(
              leading: _getThumbnail(context),
              title: Padding(
                padding: EdgeInsets.only(right: isMenuVisible ? 28.0 : 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(widget.file.name),
                    ),
                    SizedBox(height: 7.0),
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
                          ? Row(children: <Widget>[
                              Expanded(flex: 1, child: Icon(_getProcessIcon())),
                              SizedBox(width: 8.0),
                              Expanded(
                                flex: 18,
                                child: SizedBox(
                                  height: 2.0,
                                  child: LinearProgressIndicator(
                                    value: _processingFile?.processingType ==
                                            ProcessingType.upload
                                        ? null
                                        : _progress,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ])
                          : Row(
                              children: <Widget>[
                                if (widget.file.published)
                                  Icon(
                                    Icons.link,
                                    semanticLabel: s.has_public_link,
                                  ),
                                if (widget.file.published)
                                  SizedBox(width: margin),
                                if (widget.file.localId != null)
                                  Icon(
                                    Icons.airplanemode_active,
                                    semanticLabel: s.available_offline,
                                  ),
                                if (widget.file.localId != null)
                                  SizedBox(width: margin),
                                Text(filesize(widget.file.size),
                                    style: Theme.of(context).textTheme.caption),
                                SizedBox(width: margin),
                                Text("|",
                                    style: Theme.of(context).textTheme.caption),
                                SizedBox(width: margin),
                                Text(
                                    DateFormatting.formatDateFromSeconds(
                                      timestamp: widget.file.lastModified,
                                    ),
                                    style: Theme.of(context).textTheme.caption),
                                SizedBox(width: margin),
                              ],
                            ),
                    )
                  ],
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
                        ? SizedBox()
                        : IconButton(
                            icon: Icon(Icons.cancel),
                            color: Theme.of(context).disabledColor,
                            iconSize: 22.0,
                            onPressed: () {
                              _filesState.deleteFromProcessing(
                                  _processingFile.guid,
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
