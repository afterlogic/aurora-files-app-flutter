import 'login_presenter.dart';
import 'login_view.dart';
import 'package:flutter/material.dart';
import 'package:mpv/mpv.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateWithPresenter<LoginWidget, LoginPresenter>
    with LoginView {
  @override
  LoginPresenter createPresenter() => LoginPresenter(this);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
