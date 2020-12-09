
import 'package:aurorafiles/modules/auth/repository/auth_api.dart';

class BackupCodeAuthRoute {
  static const name = "BackupCodeAuthRoute";
}

class BackupCodeAuthRouteArgs {
  final bool isDialog;

  final RequestTwoFactor state;

  const BackupCodeAuthRouteArgs(
    this.isDialog,
    this.state,
  );
}
