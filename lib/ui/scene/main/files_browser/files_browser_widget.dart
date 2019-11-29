import 'files_browser_presenter.dart';
import 'files_browser_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class FilesBrowserWidget extends StatefulWidget {
  @override
  _FilesBrowserWidgetState createState() => _FilesBrowserWidgetState();
}

class _FilesBrowserWidgetState
    extends StateWithPresenter<FilesBrowserWidget, FilesBrowserPresenter>
    with FilesBrowserView {
  @override
  FilesBrowserPresenter createPresenter() => FilesBrowserPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
