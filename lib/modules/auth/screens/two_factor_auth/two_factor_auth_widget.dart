import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurora_ui_kit/components/am_button.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/auth/repository/two_factor_auth/bloc.dart';
import 'package:aurorafiles/modules/auth/screens/component/two_factor_screen.dart';
import 'package:aurorafiles/modules/auth/screens/select_two_factor/select_two_factor_route.dart';
import 'package:aurorafiles/modules/auth/screens/trust_device/trust_device_route.dart';
import 'package:aurorafiles/modules/auth/screens/two_factor_auth/two_factor_auth_route.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/shared_ui/app_input.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme/app_theme.dart';

class TwoFactorAuthWidget extends StatefulWidget {
  final TwoFactorAuthRouteArgs args;

  const TwoFactorAuthWidget(this.args, {super.key});

  @override
  _TwoFactorAuthWidgetState createState() => _TwoFactorAuthWidgetState();
}

class _TwoFactorAuthWidgetState extends State<TwoFactorAuthWidget> {
  final pinCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final bloc = TwoFactorBloc();

  @override
  void dispose() {
    pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
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
                .headline6
                ?.copyWith(color: AppTheme.loginTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            s.tfa_hint_step,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.loginTextColor),
          ),
        ],
      ),
      buttons: [
        BlocListener<TwoFactorBloc, TwoFactorState>(
          bloc: bloc,
          listener: (BuildContext context, state) {
            if (state is ErrorState) {
              pinCtrl.clear();
              _showError(state.errorMsg);
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
          child: BlocBuilder<TwoFactorBloc, TwoFactorState>(
              bloc: bloc,
              builder: (context, state) {
                final loading =
                    state is ProgressState || state is CompleteState;
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.tfa_input_hint_code_from_app,
                        style: TextStyle(color: AppTheme.loginTextColor),
                      ),
                      const SizedBox(height: 20),
                      AppInput(
                        controller: pinCtrl,
                        labelText: s.input_2fa_pin,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            validateInput(value ?? '', [ValidationTypes.empty]),
                        enabled: !loading,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: AMButton(
                          isLoading: loading,
                          onPressed: () => _login(),
                          child: Text(
                            s.btn_verify_pin,
                            style: TextStyle(color: AppTheme.loginTextColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: Text(
                            s.tfa_btn_other_options,
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
              }),
        ),
      ],
    );
  }

  void _showError(String error) {
    AuroraSnackBar.showSnack(msg: error);
  }

  _login() {
    if (formKey.currentState?.validate() == true) {
      bloc.add(
        Verify(
          pinCtrl.text,
        ),
      );
    }
  }
}
