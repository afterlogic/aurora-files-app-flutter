import 'dart:ui';

import 'package:aurorafiles/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:flutter/material.dart';

class FileViewerAndroid extends StatelessWidget {
  Widget _buildFileImage(file) {
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
          tag: file["Id"],
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

  @override
  Widget build(BuildContext context) {
    final FileViewerScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("File viewer"),
      ),
      body: Column(
        children: <Widget>[
          _buildFileImage(args.file),
          SizedBox(height: 30.0),
          Text(args.file["Name"], style: Theme.of(context).textTheme.display1,)
        ],
      ),
    );
  }
}
