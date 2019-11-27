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
    var privateKey = LocalPgpKey(
        email: result.email, isPrivate: true, length: result.length);
    var publicKey = LocalPgpKey(
        email: result.email, isPrivate: false, length: result.length);

    await refreshKeys([publicKey], [privateKey]);
    final keys = await result.keyBuilder;

    privateKey = privateKey.copyWith(key: keys.secret);
    publicKey = publicKey.copyWith(key: keys.public);

    await pgpKeyUtil.saveKeys([publicKey, privateKey]);
    refreshKeys();
  }

  close(){
    pgpKeyUtil.close();
  }
}
