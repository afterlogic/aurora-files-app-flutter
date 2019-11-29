import 'file_viewer_presenter.dart';
import 'file_viewer_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class FileViewerWidget extends StatefulWidget {
  @override
  _FileViewerWidgetState createState() => _FileViewerWidgetState();
}

class _FileViewerWidgetState extends StateWithPresenter<FileViewerWidget, FileViewerPresenter>
    with FileViewerView {
  @override
  FileViewerPresenter createPresenter() => FileViewerPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
