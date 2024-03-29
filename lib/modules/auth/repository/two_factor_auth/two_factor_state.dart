import 'package:equatable/equatable.dart';

abstract class TwoFactorState extends Equatable {
  const TwoFactorState();

  @override
  List<Object> get props => [];
}

class InitialState extends TwoFactorState {}

class ProgressState extends TwoFactorState {}

class ErrorState extends TwoFactorState {
  final String errorMsg;

  const ErrorState(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class CompleteState extends TwoFactorState {
  final int daysCount;

  const CompleteState(this.daysCount);
}
