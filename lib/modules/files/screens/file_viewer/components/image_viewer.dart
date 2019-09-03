import 'dart:ui';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key key,
    @required this.file,
  }) : super(key: key);

  final LocalFile file;

  @override
  Widget build(BuildContext context) {
    final hostName = Provider.of<AuthState>(context).hostName;

    final img = CachedNetworkImage(
      imageUrl: '$hostName/${file.viewUrl}',
      fit: BoxFit.cover,
      fadeInDuration: Duration(milliseconds: 150),
      httpHeaders: getHeader(),
    );
    final placeholder = CachedNetworkImage(
      imageUrl: '$hostName/${file.thumbnailUrl}',
      fit: BoxFit.cover,
      httpHeaders: getHeader(),
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
