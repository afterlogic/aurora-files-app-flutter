
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';

class TwoFactorAuthRoute {
  static const name = "twoFactorAuthRoute";
}

class TwoFactorAuthRouteArgs {
  final bool isDialog;

  final RequestTwoFactor state;

  const TwoFactorAuthRouteArgs(
    this.isDialog,
    this.state,
  );
}
