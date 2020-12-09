import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/repository/ios_fido_auth_bloc/state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_links/uni_links.dart';
import 'package:yubico_flutter/yubico_flutter.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tab;

import '../auth_api.dart';
import 'event.dart';

class FidoAuthBloc extends Bloc<FidoAuthEvent, FidoAuthState> {
  final String host;
  final String login;
  final String password;
  final authApi = AuthApi();
  final authState = AppStore.authState;
  FidoAuthRequest fidoRequest;
  StreamSubscription sub;

  FidoAuthBloc(this.host, this.login, this.password) {
    sub = getLinksStream().listen((event) {
      final uri = Uri.parse(event);
      if (uri.host == "u2f") {
        final query = Uri.parse(event).queryParameters;
        if (query.containsKey("error")) {
          add(Cancel());
        } else if (query.containsKey("attestation")) {
          final json = jsonDecode(query["attestation"]) as Map;
          add(KeyResult(json));
        }
      }
    });
  }

  @override
  Future<void> close() {
    sub.cancel();
    return super.close();
  }

  @override
  FidoAuthState get initialState => InitState();

  @override
  Stream<FidoAuthState> mapEventToState(FidoAuthEvent event) async* {
    if (event is StartAuth) {
      yield* _startAuth(event);
    } else if (event is KeyResult) {
      yield* _keyResult(event);
    } else if (event is Cancel) {
      yield* _cancelByUser(event);
    }
  }

  Stream<FidoAuthState> _cancelByUser(Cancel event) async* {
    fidoRequest?.close();
    fidoRequest = null;
    if (event.error != null && event.error != FidoErrorCase.Canceled) {
      yield ErrorState(event.error.toString());
    } else {
      yield ErrorState(null);
    }
  }

  Stream<FidoAuthState> _keyResult(KeyResult event) async* {
    try {
      fidoRequest?.close();
      final waitSheet = Completer();

      yield SendingFinishAuthRequestState(waitSheet);
      if (fidoRequest?.isNFC == false) {
        await waitSheet.future;
      }
      final attestation = Platform.isIOS ? event.result : event.result;
      final loginResponse = await authApi.verifySecurityKeyFinish(
        host,
        login,
        password,
        attestation,
      );
      await authState.initUser(loginResponse);
      yield Success();
    } catch (e, s) {
      if (e is PlatformException) {
        if (e.message == "No valid credentials provided.") {
          yield ErrorState(e.message);
          return;
        }
      }
      if (e is CanceledByUser) {
        yield ErrorState(null);
        return;
      }
      yield ErrorState(e.toString());
    }
  }

  Stream<FidoAuthState> _startAuth(StartAuth event) async* {
    try {
      yield SendingBeginAuthRequestState();
      if (Platform.isAndroid && false) {
        final uri = Uri.parse(
            "${AppStore.authState.hostName}?verify-security-key&login=$login&password=$password&package_name=${BuildProperty.deepLink}");

        tab.launch(uri.toString(),
            option: tab.CustomTabsOption(
              enableUrlBarHiding: true,
              enableInstantApps: true,
              extraCustomTabs: <String>[
                "com.android.chrome",
              ],
            ));
        yield WaitWebView();
        return;
      }
      final request =
          await authApi.verifySecurityKeyBegin(host, login, password);
      yield WaitKeyState();
      final domainUrl = Uri.parse(request.host).origin;
      fidoRequest = FidoAuthRequest(
        Duration(seconds: 30),
        domainUrl,
        request.timeout,
        request.challenge,
        null,
        request.rpId,
        request.allowCredentials,
      );
      final isNFC =
          await fidoRequest.waitConnection(event.message, event.success);

      if (isNFC == false) {
        yield TouchKeyState();
      }
      fidoRequest
          .start()
          .then((value) => add(KeyResult(value)))
          .catchError((e) => add(Cancel(e)));
    } catch (e) {
      if (e is PlatformException) {
        if (e.message == "No valid credentials provided.") {
          yield ErrorState(e.message);
          return;
        }
      }
      if (e is CanceledByUser) {
        yield ErrorState(null);
        return;
      }
      yield ErrorState(e.toString());
    }
  }
}
