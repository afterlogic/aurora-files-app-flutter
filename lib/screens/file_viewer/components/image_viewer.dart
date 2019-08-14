import 'dart:ui';

import 'package:aurorafiles/store/app_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key key,
    @required this.file,
  }) : super(key: key);

  final file;

  @override
  Widget build(BuildContext context) {
    final img = CachedNetworkImage(
      imageUrl: '${SingletonStore.instance.hostName}/${file["Actions"]["view"]["url"]}',
      fit: BoxFit.cover,
      httpHeaders: {'Authorization': 'Bearer ${SingletonStore.instance.authToken}'},
    );
    final placeholder = CachedNetworkImage(
      imageUrl: '${SingletonStore.instance.hostName}/${file["ThumbnailUrl"]}',
      fit: BoxFit.cover,
      httpHeaders: {'Authorization': 'Bearer ${SingletonStore.instance.authToken}'},
    );

    if (file["Actions"]["view"] != null &&
        file["Actions"]["view"]["url"] != null) {
      return Hero(
          tag: file["ThumbnailUrl"],
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
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                img,
              ],
            ),
          ));
    } else {
      return SizedBox();
    }
  }
}
