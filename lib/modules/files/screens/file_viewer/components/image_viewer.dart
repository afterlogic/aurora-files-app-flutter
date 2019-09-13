import 'dart:ui';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moor_flutter/moor_flutter.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    Key key,
    @required this.file,
    @required this.scaffoldState,
  }) : super(key: key);

  final LocalFile file;
  final ScaffoldState scaffoldState;

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  FileViewerState _fileViewerState;
  List<int> _decryptedImage;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fileViewerState = new FileViewerState();
    _fileViewerState.file = widget.file;
    if (widget.file.initVector != null) _decryptImage();
  }

  @override
  void dispose() {
    super.dispose();
    _fileViewerState.dispose();
  }

  Future _decryptImage() async {
    final decryptedImage = await _fileViewerState.onDecryptFile();
    setState(() => _decryptedImage = decryptedImage);
  }

  Widget _buildImage() {
    // if the image is encrypted
    if (widget.file.initVector != null) {
      if (_isError) {
        return Row(
          children: <Widget>[
            Icon(Icons.error),
            SizedBox(width: 16.0),
            Flexible(
              child: Text(
                  "An error occurred during the decryption process. Perhaps, this file was encrypted with another key."),
            ),
          ],
        );
      } else if (_decryptedImage == null) {
        return SizedBox(
          height: 50.0,
          width: 50.0,
          child: Center(
            child: Observer(
              builder: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    value: _fileViewerState.downloadProgress,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                  ),
                  SizedBox(width: 20.0),
                  Text(_fileViewerState.downloadProgress == null
                      ? "Decrypting file..."
                      : "Downloading file...")
                ],
              ),
            ),
          ),
        );
      } else {
        final image = Image.memory(
          Uint8List.fromList(_decryptedImage),
          fit: BoxFit.cover,
        );
        precacheImage(image.image, context, onError: (e, stackTrace) {
          setState(() => _isError = true);
        });
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50.0),
          child: image,
        );
      }
    } else {
      return CachedNetworkImage(
        imageUrl: '${AppStore.authState.hostName}/${widget.file.viewUrl}',
        fit: BoxFit.cover,
        fadeInDuration: Duration(milliseconds: 150),
        httpHeaders: getHeader(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final img = _buildImage();

    final placeholder = CachedNetworkImage(
      imageUrl: '${AppStore.authState.hostName}/${widget.file.thumbnailUrl}',
      fit: BoxFit.cover,
      httpHeaders: getHeader(),
    );

    if (widget.file.viewUrl != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Hero(
            tag: widget.file.thumbnailUrl,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  placeholder,
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8.0,
                          sigmaY: 8.0,
                        ),
                        child: Container(),
                      ),
                    ),
                  ),
                  if (widget.file.initVector == null)
                    Positioned.fill(
                      child: Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.grey.withOpacity(0.3),
                      )),
                    ),
                  img,
                ],
              ),
            )),
      );
    } else {
      return SizedBox();
    }
  }
}
