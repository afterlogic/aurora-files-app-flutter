import 'package:aurorafiles/modules/auth/repository/auth_api.dart';

class SelectTwoFactorRoute {
  static const name = "SelectTwoFactorRoute";
}

class SelectTwoFactorRouteArgs {
  final bool isDialog;
  final RequestTwoFactor state;

  const SelectTwoFactorRouteArgs(
    this.isDialog,
    this.state,
  );
}
