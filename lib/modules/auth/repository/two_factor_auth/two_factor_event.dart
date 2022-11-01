
import 'package:aurorafiles/utils/always_non_equal_object.dart';
import 'package:equatable/equatable.dart';

abstract class TwoFactorEvent extends Equatable {
  const TwoFactorEvent();

  @override
  List<Object> get props => [];
}

class Verify extends TwoFactorEvent with AlwaysNonEqualObject {
  final String pin;

  Verify(this.pin);

  @override
  List<Object> get props => [pin];
}
