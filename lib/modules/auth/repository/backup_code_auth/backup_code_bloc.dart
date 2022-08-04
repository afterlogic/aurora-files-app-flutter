import 'package:aurorafiles/modules/app_store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'backup_code_event.dart';

import 'backup_code_state.dart';

class BackupCodeBloc extends Bloc<BackupCodeEvent, BackupCodeState> {
  BackupCodeBloc() : super(InitialState());

  @override
  Stream<BackupCodeState> mapEventToState(
    BackupCodeEvent event,
  ) async* {
    if (event is Verify) yield* _logIn(event);
  }

  Stream<BackupCodeState> _logIn(Verify state) async* {
    yield ProgressState();

    try {
      final result = await AppStore.authState.backupCodeAuth(state.code);
      if (!result) {
        yield ErrorState("Invalid backup code");
        return;
      }
      await AppStore.authState.successLogin();
      final daysCount = await AppStore.authState.getTrustDevicesForDays();
      yield CompleteState(daysCount);
    } catch (err) {
      yield ErrorState(err.toString());
    }
  }
}
