import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TextViewer extends StatefulWidget {
  const TextViewer({
    Key key,
    @required this.scaffoldState,
    @required this.fileViewerState,
  }) : super(key: key);

  final ScaffoldState scaffoldState;
  final FileViewerState fileViewerState;

  @override
  _TextViewerState createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  String previewText;

  @override
  void initState() {
    super.initState();
    _initTextViewer();
  }

  Future _initTextViewer() async {
    final text = await widget.fileViewerState.onGetPreviewText();
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
                    previewText,
                    style: TextStyle(
                        fontFamily: widget.fileViewerState.file.contentType ==
                                "application/json"
                            ? "monospace"
                            : null),
                  )),
                ),
              ),
            ),
    );
  }
}
