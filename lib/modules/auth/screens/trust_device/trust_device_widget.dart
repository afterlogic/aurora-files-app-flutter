import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurora_ui_kit/components/am_button.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/repository/trust_device/bloc.dart';
import 'package:aurorafiles/modules/auth/screens/component/two_factor_screen.dart';
import 'package:aurorafiles/modules/auth/screens/trust_device/trust_device_route.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme/app_theme.dart';

class TrustDeviceWidget extends StatefulWidget {
  final TrustDeviceRouteArgs args;

  const TrustDeviceWidget({Key? key, required this.args}) : super(key: key);

  @override
  _TrustDeviceWidgetState createState() => _TrustDeviceWidgetState();
}

class _TrustDeviceWidgetState extends State<TrustDeviceWidget> {
  late TrustDeviceBloc bloc;
  bool check = false;

  @override
  void initState() {
    super.initState();
    bloc = TrustDeviceBloc(
      AppStore.authState.emailCtrl.text,
      AppStore.authState.passwordCtrl.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return TwoFactorScene(
      logoHint: "",
      isDialog: widget.args.isDialog,
      buttons: [
        BlocListener<TrustDeviceBloc, TrustDeviceState>(
          bloc: bloc,
          listener: (BuildContext context, state) {
            if (state is ErrorState) {
              _showError(state.errorMsg);
            } else if (state is CompleteState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, FilesRoute.name, (route) => route.isFirst,
                  arguments: FilesScreenArguments(path: ""));
            }
          },
          child: BlocBuilder<TrustDeviceBloc, TrustDeviceState>(
              bloc: bloc,
              builder: (context, state) {
                final loading =
                    state is ProgressState || state is CompleteState;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.tfa_label_trust_device,
                      style: TextStyle(color: AppTheme.loginTextColor),
                    ),
                    const SizedBox(height: 20),
                    IgnorePointer(
                      ignoring: loading,
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: check,
                        onChanged: (value) {
                          if (value != null) {
                            check = value;
                            setState(() {});
                          }
                        },
                        title: Text(
                          s.tfa_check_box_trust_device(
                              widget.args.daysCount.toString()),
                          style: TextStyle(color: AppTheme.loginTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: AMButton(
                        isLoading: loading,
                        onPressed: () {
                          bloc.add(TrustThisDevice(check));
                        },
                        child: Text(
                          s.tfa_button_continue,
                          style: TextStyle(color: AppTheme.loginTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
        ),
      ],
    );
  }

  void _showError(String msg) {
    AuroraSnackBar.showSnack(msg: msg);
  }
}
