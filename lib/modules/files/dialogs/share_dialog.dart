import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/models/processing_file.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:flutter/material.dart';

class ShareDialog extends StatefulWidget {
  final FilesState filesState;
  final LocalFile file;

  const ShareDialog({Key? key, required this.filesState, required this.file})
      : super(key: key);

  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _shareFile();
    });
  }

  Future _shareFile() async {
    await widget.filesState.prepareForShare(
      widget.file,
      context,
      onError: (e) {
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
    final s = context.l10n;
    return AMDialog(
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
        TextButton(
          child: Text(s.cancel.toUpperCase()),
          onPressed: () {
            widget.filesState.deleteFromProcessing(
              widget.file.guid,
              deleteLocally: true,
            );
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
