import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_presenter.dart';
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
}

class KeysState {
  final List<LocalPgpKey> public;
  final List<LocalPgpKey> private;
  final List<LocalPgpKey> user;
  final bool isProgress;

  KeysState(this.public, this.private, this.user, [this.isProgress = false]);
}

class PgpKeyMap {
  final Map<LocalPgpKey, bool> userKey;
  final Map<LocalPgpKey, bool> contactKey;

  PgpKeyMap(this.userKey, this.contactKey);
}
