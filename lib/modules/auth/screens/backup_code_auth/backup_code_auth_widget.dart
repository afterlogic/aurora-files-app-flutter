import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurora_ui_kit/components/am_button.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/auth/repository/backup_code_auth/bloc.dart';
import 'package:aurorafiles/modules/auth/screens/backup_code_auth/backup_code_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/component/two_factor_screen.dart';
import 'package:aurorafiles/modules/auth/screens/select_two_factor/select_two_factor_route.dart';
import 'package:aurorafiles/modules/auth/screens/trust_device/trust_device_route.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/shared_ui/app_input.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme/app_color.dart';
import 'package:theme/app_theme.dart';

class BackupCodeAuthWidget extends StatefulWidget {
  final BackupCodeAuthRouteArgs args;

  const BackupCodeAuthWidget(this.args);

  @override
  _BackupCodeAuthWidgetState createState() => _BackupCodeAuthWidgetState();
}

class _BackupCodeAuthWidgetState extends State<BackupCodeAuthWidget> {
  final pinCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final bloc = BackupCodeBloc();
  S s;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = Str.of(context);
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
        BlocListener<BackupCodeBloc, BackupCodeState>(
          bloc: bloc,
          listener: (BuildContext context, state) {
            if (state is ErrorState) {
              pinCtrl.clear();
              _showError(
                context,
                state.errorMsg,
              );
            } else if (state is CompleteState) {
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
            }
          },
          child: BlocBuilder<BackupCodeBloc, BackupCodeState>(
            bloc: bloc,
            builder: (context, state) {
              final loading = state is ProgressState || state is CompleteState;
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.tfa_label_enter_backup_code,
                      style: TextStyle(color: AppTheme.loginTextColor),
                    ),
                    SizedBox(height: 20),
                    AppInput(
                      controller: pinCtrl,
                      labelText: s.tfa_input_backup_code,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          validateInput(value, [ValidationTypes.empty]),
                      enabled: !loading,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: AMButton(
                        child: Text(
                          s.btn_verify_pin,
                          style: TextStyle(color: AppTheme.loginTextColor),
                        ),
                        isLoading: loading,
                        onPressed: () => _login(),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        child: Text(
                          "Other options",
                          style: TextStyle(color: AppTheme.loginTextColor),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showError(BuildContext context, String error) {
    showSnack(context, msg: error);
  }

  _login() {
    if (formKey.currentState.validate()) {
      final args = widget.args;
      bloc.add(
        Verify(
          pinCtrl.text,
        ),
      );
    }
  }
}
