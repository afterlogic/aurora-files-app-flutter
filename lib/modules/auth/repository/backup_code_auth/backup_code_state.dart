import 'package:equatable/equatable.dart';

abstract class BackupCodeState extends Equatable {
  const BackupCodeState();

  @override
  List<Object> get props => [];
}

class InitialState extends BackupCodeState {}

class ProgressState extends BackupCodeState {}

class ErrorState extends BackupCodeState {
  final String errorMsg;

  ErrorState(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class CompleteState extends BackupCodeState {
  CompleteState();
}
