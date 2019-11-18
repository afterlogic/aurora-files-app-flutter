import 'package:aurorafiles/database/app_database.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

mixin PgpSettingView<W extends StatefulWidget> on State<W> {
  final keysState = BehaviorSubject<KeysState>();

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
  final List<LocalPgpKey> keys;
  final bool isProgress;

  KeysState(this.keys, [this.isProgress = false]);
}
