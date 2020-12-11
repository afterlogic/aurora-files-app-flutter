import 'dart:async';

import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/generated/string/s.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/auth/repository/ios_fido_auth_bloc/bloc.dart';
import 'package:aurorafiles/modules/auth/repository/ios_fido_auth_bloc/event.dart';
import 'package:aurorafiles/modules/auth/repository/ios_fido_auth_bloc/state.dart';
import 'package:aurorafiles/modules/auth/screens/component/two_factor_screen.dart';
import 'package:aurorafiles/modules/auth/screens/select_two_factor/select_two_factor_route.dart';
import 'package:aurorafiles/modules/auth/screens/trust_device/trust_device_route.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme/app_color.dart';
import 'package:theme/app_theme.dart';

import 'nfc_dialog.dart';
import 'fido_auth_route.dart';

class FidoAuthWidget extends StatefulWidget {
  final FidoAuthRouteArgs args;

  const FidoAuthWidget(this.args);

  @override
  _FidoAuthWidgetState createState() => _FidoAuthWidgetState();
}

class _FidoAuthWidgetState extends State<FidoAuthWidget> {
  FidoAuthBloc bloc;
  S s;
  ThemeData theme;
  final touchDialogKey = GlobalKey<IosPressOnKeyDialogState>();

  @override
  void initState() {
    super.initState();

    bloc = FidoAuthBloc(
      AppStore.authState.apiUrl,
      AppStore.authState.emailCtrl.text,
      AppStore.authState.passwordCtrl.text,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      s = Str.of(context);
      bloc.add(
          StartAuth(true, s.fido_label_connect_your_key, s.fido_label_success));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = Str.of(context);
    theme = Theme.of(context);
  }

  @override
  dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TwoFactorScene(
      logoHint: "",
      isDialog: widget.args.isDialog,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            s.tfa_label,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: AppTheme.loginTextColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            s.tfa_hint_step,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.loginTextColor),
          ),
        ],
      ),
      button: [
        BlocListener<FidoAuthBloc, FidoAuthState>(
          bloc: bloc,
          listener: (BuildContext context, state) {
            if (state is Success) {
              if (state.daysCount == 0) {
                Navigator.pushReplacementNamed(
                  context,
                  FilesRoute.name,
                  arguments: FilesScreenArguments(path: ""),
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  TrustDeviceRoute.name,
                  arguments: TrustDeviceRouteArgs(
                    widget.args.isDialog,
                    state.daysCount,
                  ),
                );
              }
              return;
            }
            if (state is ErrorState) {
              if (state.errorToShow != null) {
                _showError(context, state.errorToShow);
              }
            }
            if (state is TouchKeyState) {
              if (touchDialogKey.currentState != null) {
                touchDialogKey.currentState.close();
              }
              IosPressOnKeyDialog(touchDialogKey, () => bloc.add(Cancel()))
                  .show(context);
            } else if (state is SendingFinishAuthRequestState) {
              if (touchDialogKey.currentState != null) {
                touchDialogKey.currentState
                    .success()
                    .then((value) => state.waitSheet?.complete());
              } else {
                state.waitSheet?.complete();
              }
            } else {
              if (touchDialogKey.currentState != null) {
                touchDialogKey.currentState.close();
              }
            }
          },
          child: BlocBuilder<FidoAuthBloc, FidoAuthState>(
              bloc: bloc,
              builder: (_, state) {
                return state is InitState || state is ErrorState
                    ? Column(
                        children: [
                          Text(
                            s.fido_error_title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.title
                                .copyWith(color: AppTheme.loginTextColor),
                          ),
                          SizedBox(height: 10),
                          Text(
                            s.fido_error_hint,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.loginTextColor),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: AMButton(

                              child: Text(
                                s.fido_btn_try_again,
                                style:
                                    TextStyle(color: AppTheme.loginTextColor),
                              ),
                              onPressed: () {
                                bloc.add(StartAuth(
                                  true,
                                  s.fido_label_connect_your_key,
                                  s.fido_label_success,
                                ));
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              child: Text(
                                s.tfa_btn_other_options,
                                style:
                                    TextStyle(color: AppTheme.loginTextColor),
                              ),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  SelectTwoFactorRoute.name,
                                  ModalRoute.withName(AuthRoute.name),
                                  arguments: SelectTwoFactorRouteArgs(
                                      widget.args.isDialog, widget.args.state),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : (state is WaitWebView
                        ? Center(
                            child: Column(
                            children: [
                              CircularProgressIndicator(),
                              FlatButton(
                                onPressed: () {
                                  bloc.add(Cancel());
                                },
                                child: Text(
                                  s.cancel,
                                ),
                              )
                            ],
                          ))
                        : Center(
                            child: CircularProgressIndicator(),
                          ));
              }),
        ),
      ],
    );
  }

  void _showError(BuildContext context, String msg) {
    showSnack(context: context, scaffoldState: Scaffold.of(context), msg: msg);
  }
}
