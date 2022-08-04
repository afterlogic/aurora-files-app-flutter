import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'trust_device_event.dart';
import 'trust_device_methods.dart';
import 'trust_device_state.dart';

class TrustDeviceBloc extends Bloc<TrustDeviceEvent, TrustDeviceState> {
  final _methods = TrustDeviceMethods();
  final String login;
  final String password;

  TrustDeviceBloc(this.login, this.password) : super(InitialState());

  @override
  Stream<TrustDeviceState> mapEventToState(
    TrustDeviceEvent event,
  ) async* {
    if (event is TrustThisDevice) yield* _trustThisDevice(event);
  }

  Stream<TrustDeviceState> _trustThisDevice(TrustThisDevice state) async* {
    yield ProgressState();

    try {
      if (state.trust) {
        await _methods.trustDevice(login, password);
      }
      yield CompleteState();
    } catch (err, s) {
      yield ErrorState(s.toString());
    }
  }
}
