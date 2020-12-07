import 'package:aurorafiles/modules/auth/repository/auth_api.dart';

class FidoAuthRoute {
  static const name = "FidoAuthRoute";
}

class FidoAuthRouteArgs {
  final bool isDialog;
  final RequestTwoFactor state;

  const FidoAuthRouteArgs(
    this.isDialog,
    this.state,
  );
}
