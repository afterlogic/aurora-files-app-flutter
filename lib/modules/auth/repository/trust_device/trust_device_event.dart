import 'package:aurorafiles/utils/always_non_equal_object.dart';
import 'package:equatable/equatable.dart';

abstract class TrustDeviceEvent extends Equatable {
  const TrustDeviceEvent();

  @override
  List<Object> get props => [];
}

class TrustThisDevice extends TrustDeviceEvent with AlwaysNonEqualObject {
  final bool trust;

  TrustThisDevice(this.trust);
}
