import 'dart:math';
import 'dart:ui';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/shared_ui/progress_loader.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moor_flutter/moor_flutter.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    Key key,
    @required this.fileViewerState,
    @required this.scaffoldState,
    this.password,
  }) : super(key: key);
  final String password;
  final FileViewerState fileViewerState;
  final ScaffoldState scaffoldState;

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  S s;
  FileViewerState _fileViewerState;
  bool _isError = false;
  Widget builtImage;
  Future decryptFuture;
  BoxFit fit = BoxFit.cover;

  @override
  void initState() {
    super.initState();
    _fileViewerState = widget.fileViewerState;
    if (!AppStore.filesState.isOfflineMode) {
      Future.delayed(
        Duration(milliseconds: 250),
        () => _fileViewerState.getPreviewImage(
            widget.password, (err) => showError(err), context),
      );
    } else if (_fileViewerState.file.initVector != null) {
      decryptFuture = _fileViewerState.decryptOfflineFile(widget.password);
    }
  }

  @override
  void dispose() {
    super.dispose();
    AppStore.filesState.clearCache();
  }

  void showError(String err) {
    if (err == "Invalid password" || err == "Instance of 'CryptoException'") {
      _isError = true;
      setState(() {});
    } else if (err.isNotEmpty)
      showSnack(
        context: context,
        scaffoldState: Scaffold.of(context),
        msg: err,
      );
  }

  Widget _buildImage() {
    // if the image is encrypted
    if (_fileViewerState.file.initVector != null) {
      if (_isError) {
        return Row(
          children: <Widget>[
            Icon(Icons.error),
            SizedBox(width: 16.0),
            Flexible(
              child: Text(s.decrypt_error),
            ),
          ],
        );
      } else if (_fileViewerState.downloadProgress != null) {
        return Positioned.fill(
          child: Center(
            child: ProgressLoader(min(
              1.0,
              _fileViewerState.downloadProgress ?? 0,
            )),
          ),
        );
      } else {
        if (_fileViewerState.fileWithContents == null) {
          return SizedBox.shrink();
        }
        final image = Image.file(
          _fileViewerState.fileWithContents,
          fit: fit,
        );
//        precacheImage(image.image, context, onError: (e, stackTrace) {
//          Future.delayed(Duration(milliseconds: 100),
//              () => setState(() => _isError = true));
//        });
        return Positioned.fill(child: image);
      }
    } else {
      if (_isError) {
        return Row(
          children: <Widget>[
            Icon(Icons.error),
            SizedBox(width: 16.0),
            Flexible(
              child: Text(s.file_is_damaged),
            ),
          ],
        );
      } else if (_fileViewerState.fileWithContents == null) {
        return Positioned.fill(
          child: Center(
            child: ProgressLoader(min(
              1.0,
              _fileViewerState.downloadProgress ?? 0,
            )),
          ),
        );
      } else {
        final image = Image.file(
          _fileViewerState.fileWithContents,
          fit: fit,
        );
        precacheImage(image.image, context, onError: (e, stack) {
          Future.delayed(
              Duration(milliseconds: 100),
              () => setState(
                    () => _isError = true,
                  ));
        });
        return Positioned.fill(child: image);
      }
    }
  }

  Widget _buildOfflineImage() {
    if (_fileViewerState.file.initVector != null) {
      return FutureBuilder(
        future: decryptFuture,
        builder: (context, snap) {
          if (snap.error != null) {
            return Row(
              children: <Widget>[
                Icon(Icons.error),
                SizedBox(width: 16.0),
                Flexible(
                  child: Text(s.decrypt_error),
                ),
              ],
            );
          } else if (snap.data == null) {
            return SizedBox.shrink();
          }
          return Image.memory(
            snap.data,
            fit: fit,
          );
        },
      );
    } else {
      return Image.file(
        _fileViewerState.fileWithContents,
        fit: fit,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    s = Str.of(context);
    double prevProgress = 999;
    Widget placeholder;
    if (_fileViewerState.file.initVector != null) {
      placeholder = null;
    } else if (AppStore.filesState.isOfflineMode) {
      if (_fileViewerState.fileWithContents != null) {
        placeholder = Image.file(
          _fileViewerState.fileWithContents,
          fit: BoxFit.cover,
        );
      }
    } else {
      final thumbUrl = _fileViewerState.file.thumbnailUrl;
      placeholder = thumbUrl != null
          ? CachedNetworkImage(
              imageUrl: '${AppStore.authState.hostName}/$thumbUrl',
              fit: BoxFit.cover,
              httpHeaders: getHeader(),
            )
          : Image.asset(
              "lib/assets/images/image_placeholder.jpg",
              fit: BoxFit.cover,
            );
    }

    if (_fileViewerState.file.viewUrl != null) {
      return Hero(
          tag: _fileViewerState.file.localId ??
              _fileViewerState.file.guid ??
              _fileViewerState.file.hash,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 60.0,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: SizedBox(
              width: double.infinity,
              child: AppStore.filesState.isOfflineMode &&
                      _fileViewerState.fileWithContents != null
                  ? _buildOfflineImage()
                  : Stack(
                      children: <Widget>[
                        if (!_isError && placeholder != null)
                          SizedBox(width: double.infinity, child: placeholder),
                        Positioned.fill(
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 8.0,
                                sigmaY: 8.0,
                              ),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Observer(
                          builder: (_) {
                            if (prevProgress !=
                                _fileViewerState.downloadProgress) {
                              builtImage = _buildImage();
                              prevProgress = _fileViewerState.downloadProgress;
                            }
                            return builtImage;
                          },
                        ),
                      ],
                    ),
            ),
          ));
    } else {
      return SizedBox();
    }
  }
}
