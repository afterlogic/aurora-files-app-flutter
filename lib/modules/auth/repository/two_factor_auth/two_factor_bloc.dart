import 'package:aurorafiles/modules/app_store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'two_factor_event.dart';

import 'two_factor_state.dart';

class TwoFactorBloc extends Bloc<TwoFactorEvent, TwoFactorState> {
  TwoFactorBloc() : super(InitialState());

  @override
  Stream<TwoFactorState> mapEventToState(TwoFactorEvent event,) async* {
    if (event is Verify) yield* _logIn(event);
  }

  Stream<TwoFactorState> _logIn(Verify state) async* {
    yield ProgressState();

    try {
      final result = await AppStore.authState.twoFactorAuth(state.pin);
      if (!result) {
        yield ErrorState("Invalid pin");
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
