import 'dart:ui';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/utils/api_utils.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key key,
    @required this.file,
    @required this.scaffoldState,
  }) : super(key: key);

  final LocalFile file;
  final ScaffoldState scaffoldState;

  @override
  Widget build(BuildContext context) {
    final hostName = Provider.of<AuthState>(context).hostName;

    final img = file.initVector != null
        ? FutureBuilder(
            future: AppStore.filesState.onDecryptFile(file: file),
            builder: (_, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Image(
                  fit: BoxFit.cover,
                  image: MemoryImage(Uint8List.fromList(snapshot.data)),
                );
              } else if (snapshot.hasError) {
                showSnack(
                    context: context,
                    scaffoldState: scaffoldState,
                    msg: snapshot.error);
                return SizedBox();
              } else {
                return SizedBox(height: 50, width: 50);
              }
            },
          )
        : CachedNetworkImage(
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
                        color: Theme.of(context).scaffoldBackgroundColor,
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
