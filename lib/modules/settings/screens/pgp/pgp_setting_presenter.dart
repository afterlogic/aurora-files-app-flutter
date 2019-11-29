import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';
import 'package:crypto_plugin/algorithm/pgp.dart';
import 'package:domain/api/cache/database/pgp_key_cache_api.dart';
import 'package:domain/model/bd/pgp_key.dart';

class PgpSettingPresenter {
  final PgpSettingView _view;
  final PgpKeyCacheApi _pgpKeyDao;
  final PgpKeyUtil pgpKeyUtil;

  PgpSettingPresenter(this._view, this._pgpKeyDao, Pgp pgp)
      : pgpKeyUtil = PgpKeyUtil(pgp, _pgpKeyDao);

  getPublicKey() {
    _pgpKeyDao.getAll().then(
      (keys) {
        _view.keysState.add(KeysState(keys));
      },
      onError: (e) {
        _view.keysState.add(KeysState([]));
      },
    );
  }

  getKeysFromFile() async {
    final result = await pgpKeyUtil.importKeyFromFile();
    if (result != null && result.isNotEmpty) {
      getPublicKey();
    }
  }

  getKeysFromText(String text) async {
    final result = await pgpKeyUtil.validateText(text);
    if (result.isNotEmpty) {
      getPublicKey();
    }
  }

  Future<String> exportAll(List<PgpKey> keys) async {
    for (PgpKey key in keys) {
      await pgpKeyUtil.downloadKey(key);
    }
    return await pgpKeyUtil.keysFolder();
  }
}
