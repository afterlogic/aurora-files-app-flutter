import 'common_presenter.dart';
import 'common_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class CommonWidget extends StatefulWidget {
  @override
  _CommonWidgetState createState() => _CommonWidgetState();
}

class _CommonWidgetState extends StateWithPresenter<CommonWidget, CommonPresenter>
    with CommonView {
  @override
  CommonPresenter createPresenter() => CommonPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
