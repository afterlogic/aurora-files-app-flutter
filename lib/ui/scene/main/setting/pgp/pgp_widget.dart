import 'pgp_presenter.dart';
import 'pgp_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class PgpWidget extends StatefulWidget {
  @override
  _PgpWidgetState createState() => _PgpWidgetState();
}

class _PgpWidgetState extends StateWithPresenter<PgpWidget, PgpPresenter>
    with PgpView {
  @override
  PgpPresenter createPresenter() => PgpPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
