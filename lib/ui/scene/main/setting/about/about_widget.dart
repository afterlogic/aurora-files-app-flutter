import 'about_presenter.dart';
import 'about_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class AboutWidget extends StatefulWidget {
  @override
  _AboutWidgetState createState() => _AboutWidgetState();
}

class _AboutWidgetState extends StateWithPresenter<AboutWidget, AboutPresenter>
    with AboutView {
  @override
  AboutPresenter createPresenter() => AboutPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
