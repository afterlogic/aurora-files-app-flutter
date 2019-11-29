import 'setting_presenter.dart';
import 'setting_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends StateWithPresenter<SettingWidget, SettingPresenter>
    with SettingView {
  @override
  SettingPresenter createPresenter() => SettingPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
