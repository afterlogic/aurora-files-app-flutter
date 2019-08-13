import 'dart:ui';

import 'package:aurorafiles/screens/file_viewer/state/file_viewer_state.dart';
import 'package:aurorafiles/store/app_state.dart';
import 'package:flutter/material.dart';

class FileViewerAndroid extends StatelessWidget {
  final file;

  FileViewerAndroid({Key key, @required this.file}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showErrSnack(BuildContext context, String msg) {
    final snack = SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).errorColor,
    );

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  void _showInfoSnack(BuildContext context, String msg) {
    final snack = SnackBar(
      content: Text(msg),
    );

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snack);
  }

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
    final fileViewerState = FileViewerState();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("File viewer"),
        actions: <Widget>[
          if (file["Actions"]["download"] != null &&
              file["Actions"]["download"]["url"] != null)
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () => fileViewerState.onDownloadFile(
                url: file["Actions"]["download"]["url"],
                fileName: file["Name"],
                onStart: () => _showInfoSnack(context, "Downloading ${file["Name"]}"),
                onSuccess: () => _showInfoSnack(context, "${file["Name"]} downloaded successfully"),
                onError: (err) => _showErrSnack(context, err.toString()),
              ),
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildFileImage(file),
          SizedBox(height: 30.0),
          Text(
            file["Name"],
            style: Theme.of(context).textTheme.display1,
          )
        ],
      ),
    );
  }
}
