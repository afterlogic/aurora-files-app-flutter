import 'dart:ui';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key key,
    @required this.file,
  }) : super(key: key);

  final File file;

  @override
  Widget build(BuildContext context) {
    final img = CachedNetworkImage(
      imageUrl: '${SingletonStore.instance.hostName}/${file.viewUrl}',
      fit: BoxFit.cover,
      fadeInDuration: Duration(milliseconds: 150),
      httpHeaders: {
        'Authorization': 'Bearer ${SingletonStore.instance.authToken}'
      },
    );
    final placeholder = CachedNetworkImage(
      imageUrl: '${SingletonStore.instance.hostName}/${file.thumbnailUrl}',
      fit: BoxFit.cover,
      httpHeaders: {
        'Authorization': 'Bearer ${SingletonStore.instance.authToken}'
      },
    );

    if (file.viewUrl != null) {
      return Hero(
          tag: file.thumbnailUrl,
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
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
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
