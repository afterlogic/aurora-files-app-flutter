import 'package:aurorafiles/utils/always_non_equal_object.dart';
import 'package:equatable/equatable.dart';

abstract class FidoAuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartAuth extends FidoAuthEvent with AlwaysNonEqualObject {
  final bool nfc;
  final String message;
  final String success;

  StartAuth(this.nfc, this.message, this.success);
}

class KeyResult extends FidoAuthEvent with AlwaysNonEqualObject {
  final Map result;

  KeyResult(this.result);
}

class Cancel extends FidoAuthEvent with AlwaysNonEqualObject {
  final dynamic error;

  Cancel([this.error]);
}
