import 'package:aurorafiles/database/app_database.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

mixin PgpSettingView<W extends StatefulWidget> on State<W> {
  final keysState = BehaviorSubject<KeysState>();

  importKeyDialog();

  close() {
    keysState.close();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  showImportDialog(PgpKeyMap result);

  keysNotFound();

  showError(String error);
}

class KeysState {
  final List<LocalPgpKey> public;
  final List<LocalPgpKey> private;
  final List<LocalPgpKey> external;
  final bool isProgress;
  final bool storePassword;

  KeysState(this.public, this.private, this.external, this.storePassword,
      [this.isProgress = false]);
}

class PgpKeyMap {
  final Map<LocalPgpKey, bool> userKeys;
  final Map<LocalPgpKey, bool> contactKeys;
  final Map<LocalPgpKey, bool> alienKeys;

  PgpKeyMap(this.userKeys, this.contactKeys, this.alienKeys);
}
