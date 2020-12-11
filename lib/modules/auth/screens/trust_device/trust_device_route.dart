class TrustDeviceRoute {
  static const name = "TrustDeviceRoute";
}

class TrustDeviceRouteArgs {
  final bool isDialog;
  final int daysCount;

  const TrustDeviceRouteArgs(
    this.isDialog,
    this.daysCount,
  );
}
