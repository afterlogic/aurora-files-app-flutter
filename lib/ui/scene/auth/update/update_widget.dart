import 'update_presenter.dart';
import 'update_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class UpdateWidget extends StatefulWidget {
  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends StateWithPresenter<UpdateWidget, UpdatePresenter>
    with UpdateView {
  @override
  UpdatePresenter createPresenter() => UpdatePresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
