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

  showImportDialog(List<LocalPgpKey> result);

   keysNotFound();
}

class KeysState {
  final List<LocalPgpKey> public;
  final List<LocalPgpKey> private;
  final bool isProgress;

  KeysState(this.public, this.private, [this.isProgress = false]);
}
