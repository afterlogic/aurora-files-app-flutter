import 'dart:io';

import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
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
  S s;
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
    s = Str.of(context);
    if (PlatformOverride.isIOS) {
      return CupertinoAlertDialog(
        title: Text(s.share_file),
        content: Column(children: [
          SizedBox(height: 6.0),
          Text(s.getting_file_progress),
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
            child: Text(s.cancel),
            onPressed: Navigator.of(context).pop,
          )
        ],
      );
    } else {
      return AlertDialog(
        title: Text(s.share_file),
        content: Row(children: [
          CircularProgressIndicator(
            value: _downloadProgress,
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(width: 20.0),
          Text(s.getting_file_progress),
        ]),
        actions: <Widget>[
          FlatButton(
            child: Text(s.cancel.toUpperCase()),
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
