
import 'package:aurorafiles/utils/always_non_equal_object.dart';
import 'package:equatable/equatable.dart';

abstract class BackupCodeEvent extends Equatable {
  const BackupCodeEvent();

  @override
  List<Object> get props => [];
}

class Verify extends BackupCodeEvent with AlwaysNonEqualObject {
  final String code;

  Verify(this.code);

  @override
  List<Object> get props => [code];
}
