import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';
import 'package:crypto_plugin/algorithm/pgp.dart';

import 'dialog/create_key_dialog.dart';

class PgpSettingPresenter {
  final PgpSettingView _view;
  final PgpKeyDao _pgpKeyDao;
  final PgpKeyUtil pgpKeyUtil;

  PgpSettingPresenter(this._view, this._pgpKeyDao, Pgp pgp)
      : pgpKeyUtil = PgpKeyUtil(pgp, _pgpKeyDao);

  refreshKeys() {
    _pgpKeyDao.getKeys().then(
      (keys) {
        final public = <LocalPgpKey>[];
        final private = <LocalPgpKey>[];
        keys.forEach((item) {
          if (item.isPrivate) {
            private.add(item);
          } else {
            public.add(item);
          }
        });
        _view.keysState.add(KeysState(public, private));
      },
      onError: (e) {
        _view.keysState.add(KeysState([], []));
      },
    );
  }

  getKeysFromFile() async {
    final result = await pgpKeyUtil.importKeyFromFile();
    if (result != null && result.isNotEmpty) {
      _view.showImportDialog(result);
    }
  }

  getKeysFromText(String text) async {
    final result = await pgpKeyUtil.validateText(text);
    if (result != null && result.isNotEmpty) {
      _view.showImportDialog(result);
    }
  }

  Future<String> exportAll(List<LocalPgpKey> keys) async {
    for (LocalPgpKey key in keys) {
      await pgpKeyUtil.downloadKey(key);
    }
    return await pgpKeyUtil.keysFolder();
  }

  saveKeys(List<LocalPgpKey> result) async {
    await pgpKeyUtil.saveKeys(result);
    refreshKeys();
  }

  addPrivateKey(CreateKeyResult result) async {
    if (result.needUpdate) {
      refreshKeys();
    }

    final keys = await result.keyBuilder;
    final privateKey = LocalPgpKey(
        email: result.email,
        key: keys.secret,
        isPrivate: true,
        length: result.length);
    final publicKey = LocalPgpKey(
        email: result.email,
        key: keys.public,
        isPrivate: false,
        length: result.length);
    await pgpKeyUtil.saveKeys([publicKey, privateKey]);
    refreshKeys();
  }
}
