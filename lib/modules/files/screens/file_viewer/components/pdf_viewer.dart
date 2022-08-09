import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PdfViewer extends StatefulWidget {
  final LocalFile file;
  final ScaffoldState? scaffoldState;

  const PdfViewer({
    Key? key,
    required this.file,
    this.scaffoldState,
  }) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final _fileViewerState = new FileViewerState();
  late S s;

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
    s = Str.of(context);
    return Observer(
      builder: (context) {
        final downloadProgress = _fileViewerState.downloadProgress;
        return downloadProgress != null && downloadProgress < 1.0
            ? SizedBox(
                height: 3.0,
                child: LinearProgressIndicator(
                    value: _fileViewerState.downloadProgress),
              )
            : AMButton(
                child: Text(s.open_PDF),
                onPressed: () => _fileViewerState.onOpenPdf(context),
              );
      },
    );
  }
}
