import 'package:equatable/equatable.dart';

abstract class TrustDeviceState extends Equatable {
  const TrustDeviceState();

  @override
  List<Object> get props => [];
}

class InitialState extends TrustDeviceState {}

class ProgressState extends TrustDeviceState {}

class ErrorState extends TrustDeviceState {
  final String errorMsg;

  const ErrorState(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class CompleteState extends TrustDeviceState {
  const CompleteState();
}
