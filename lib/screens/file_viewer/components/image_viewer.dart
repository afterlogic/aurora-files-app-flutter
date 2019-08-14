import 'dart:ui';

import 'package:aurorafiles/store/app_state.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key key,
    @required this.file,
  }) : super(key: key);

  final file;

  @override
  Widget build(BuildContext context) {
    final img = Image.network(
      '${SingletonStore.instance.hostName}/${file["Actions"]["view"]["url"]}',
      fit: BoxFit.cover,
      headers: {'Authorization': 'Bearer ${SingletonStore.instance.authToken}'},
    );
    final placeholder = Image.network(
      '${SingletonStore.instance.hostName}/${file["ThumbnailUrl"]}',
      fit: BoxFit.cover,
      headers: {'Authorization': 'Bearer ${SingletonStore.instance.authToken}'},
    );

    if (file["Actions"]["view"] != null &&
        file["Actions"]["view"]["url"] != null) {
      return Hero(
          tag: file["Size"],
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
