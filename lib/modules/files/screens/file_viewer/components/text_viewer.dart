import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TextViewer extends StatefulWidget {
  const TextViewer({
    Key key,
    @required this.file,
    @required this.scaffoldState,
  }) : super(key: key);

  final LocalFile file;
  final ScaffoldState scaffoldState;

  @override
  _TextViewerState createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  final _fileViewerState = new FileViewerState();
  String previewText;

  @override
  void initState() {
    super.initState();
    _initTextViewer();
  }

  @override
  void dispose() {
    super.dispose();
    _fileViewerState.dispose();
  }

  Future _initTextViewer() async {
    _fileViewerState.file = widget.file;
    final text = await _fileViewerState.onGetPreviewText();
    setState(() => previewText = text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: previewText == null
          ? Observer(
              builder: (_) => Center(
                      child: CircularProgressIndicator(
                    value: _fileViewerState.downloadProgress,
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
                    previewText,
                    style: TextStyle(
                        fontFamily:
                            widget.file.contentType == "application/json"
                                ? "monospace"
                                : null),
                  )),
                ),
              ),
            ),
    );
  }
}
