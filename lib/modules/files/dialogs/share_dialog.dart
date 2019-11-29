import 'dart:io';

import 'package:domain/model/bd/local_file.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShareDialog extends StatefulWidget {
  final FilesState filesState;
  final LocalFile file;

  const ShareDialog({Key key, @required this.filesState, @required this.file})
      : super(key: key);

  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _shareFile();
  }

  Future _shareFile() async {
    await widget.filesState.prepareForShare(
      widget.file,
      onError: (e) {
        //todo show error
        e;
        Navigator.pop(context);
      },
      onSuccess: (preparedForShare) {
        Navigator.pop(context, preparedForShare);
      },
      onStart: (ProcessingFile process) {
        process.progressStream.listen((progress) {
          setState(() => _downloadProgress = progress);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text("Share file"),
        content: Column(children: [
          SizedBox(height: 6.0),
          Text("Getting file for sharing..."),
          SizedBox(height: 12.0),
          SizedBox(
            height: 2.0,
            child: LinearProgressIndicator(
              value: _downloadProgress,
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
          ),
        ]),
        actions: <Widget>[
          CupertinoButton(
            child: Text("Cancel"),
            onPressed: Navigator.of(context).pop,
          )
        ],
      );
    } else {
      return AlertDialog(
        title: Text("Share file"),
        content: Row(children: [
          CircularProgressIndicator(
            value: _downloadProgress,
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(width: 20.0),
          Text("Getting file for sharing..."),
        ]),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {
              widget.filesState
                  .deleteFromProcessing(widget.file.guid, deleteLocally: true);
              Navigator.pop(context);
            },
          )
        ],
      );
    }
  }
}
