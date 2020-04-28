import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';
import 'package:crypto_plugin/algorithm/pgp.dart';

import 'dialog/create_key_dialog.dart';

class PgpSettingPresenter {
  final PgpSettingView _view;
  final PgpKeyDao _pgpKeyDao;
  final PgpKeyUtil pgpKeyUtil;

  PgpSettingPresenter(this._view, this._pgpKeyDao, Pgp pgp)
      : pgpKeyUtil = PgpKeyUtil.instance;

  Future refreshKeys(
      [List<LocalPgpKey> addedPublic, List<LocalPgpKey> addedPrivate]) {
    return _pgpKeyDao.getKeys().then(
      (keys) {
        final public = addedPublic ?? <LocalPgpKey>[];
        final private = addedPrivate ?? <LocalPgpKey>[];
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
    if (result.isNotEmpty) {
      _view.showImportDialog(result);
    } else {
      _view.keysNotFound();
    }
  }

  getKeysFromText(String text) async {
    final result = await pgpKeyUtil.validateText(text);
    if (result.isNotEmpty) {
      _view.showImportDialog(result);
    } else {
      _view.keysNotFound();
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
    var privateKey = LocalPgpKey(
        email: result.email,
        isPrivate: true,
        length: result.length,
        name: result.name);
    var publicKey = LocalPgpKey(
        email: result.email,
        isPrivate: false,
        length: result.length,
        name: result.name);

    await refreshKeys([publicKey], [privateKey]);
    final keys = await result.keyBuilder;

    privateKey = privateKey.copyWith(key: keys.secret);
    publicKey = publicKey.copyWith(key: keys.public);

    await pgpKeyUtil.saveKeys([publicKey, privateKey]);
    refreshKeys();
  }

  close() {
    pgpKeyUtil.close();
  }
}
