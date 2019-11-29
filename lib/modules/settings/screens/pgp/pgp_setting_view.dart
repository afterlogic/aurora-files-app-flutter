import 'package:domain/model/bd/pgp_key.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

mixin PgpSettingView<W extends StatefulWidget> on State<W> {
  final keysState = BehaviorSubject<KeysState>();

  importKeyDialog(String text);

  close() {
    keysState.close();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }
}

class KeysState {
  final List<PgpKey> keys;
  final bool isProgress;

  KeysState(this.keys, [this.isProgress = false]);
}
