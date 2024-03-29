import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:aurorafiles/utils/file_content_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TextViewer extends StatefulWidget {
  const TextViewer({
    Key? key,
    required this.fileViewerState,
    this.password,
    this.scaffoldState,
  }) : super(key: key);

  final FileViewerState fileViewerState;
  final String? password;
  final ScaffoldState? scaffoldState;

  @override
  _TextViewerState createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  String? previewText;
  late LocalFile file;

  @override
  void initState() {
    super.initState();
    _initTextViewer();
  }

  @override
  void dispose() {
    super.dispose();
    AppStore.filesState.clearCache();
  }

  Future _initTextViewer() async {
    file = widget.fileViewerState.file;
    if (AppStore.filesState.isOfflineMode) {
      final fileText = String.fromCharCodes(
          await widget.fileViewerState.decryptOfflineFile(widget.password));
      setState(() => previewText = fileText);
    } else {
      widget.fileViewerState.getPreviewText(
        widget.password ?? '',
        (String fileText) {
          setState(() => previewText = fileText);
        },
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return previewText == null
        ? Observer(
            builder: (_) => Center(
                    child: CircularProgressIndicator(
                  value: widget.fileViewerState.downloadProgress,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                )))
        : ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  200 -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                  )
                ],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: SelectableText(
                    previewText ?? '',
                    style: TextStyle(
                        fontFamily: getFileType(file) == FileType.code
                            ? "monospace"
                            : "sans-serif"),
                  ),
                ),
              ),
            ),
          );
  }
}
