import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PdfViewer extends StatefulWidget {
  final LocalFile file;
  final ScaffoldState scaffoldState;

  const PdfViewer({Key key, @required this.file, @required this.scaffoldState})
      : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final _fileViewerState = new FileViewerState();

  @override
  void initState() {
    super.initState();
    _fileViewerState.file = widget.file;
  }

  @override
  void dispose() {
    super.dispose();
    _fileViewerState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Observer(
        builder: (_) => _fileViewerState.downloadProgress != null &&
                _fileViewerState.downloadProgress < 1.0
            ? SizedBox(
                height: 3.0,
                child: LinearProgressIndicator(
                    value: _fileViewerState.downloadProgress),
              )
            : AppButton(
                text: "Download and open PDF",
                onPressed: _fileViewerState.onOpenPdf,
              ),
      ),
    );
  }
}
