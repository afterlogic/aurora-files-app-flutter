import 'encryption_presenter.dart';
import 'encryption_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class EncryptionWidget extends StatefulWidget {
  @override
  _EncryptionWidgetState createState() => _EncryptionWidgetState();
}

class _EncryptionWidgetState extends StateWithPresenter<EncryptionWidget, EncryptionPresenter>
    with EncryptionView {
  @override
  EncryptionPresenter createPresenter() => EncryptionPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
