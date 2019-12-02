import 'package:aurorafiles/ui/view/app_button.dart';
import 'package:domain/model/bd/local_file.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
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
    AppStore.filesState.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => _fileViewerState.downloadProgress != null &&
              _fileViewerState.downloadProgress < 1.0
          ? SizedBox(
              height: 3.0,
              child: LinearProgressIndicator(
                  value: _fileViewerState.downloadProgress),
            )
          : AppButton(
              text: "Open PDF",
              onPressed: _fileViewerState.onOpenPdf,
            ),
    );
  }
}
