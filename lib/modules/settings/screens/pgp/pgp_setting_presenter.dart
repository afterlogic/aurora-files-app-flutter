import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';

class PgpSettingPresenter {
  final PgpSettingView _view;
  final PgpKeyDao _filesDao;

  PgpSettingPresenter(this._view, this._filesDao);

  setKey(String email, String key) {}

  getPublicKey() {
    _filesDao.getPublicKey().then(
      (keys) {
        _view.keysState.add(KeysState(keys));
      },
      onError: (e) {
        _view.keysState.add(KeysState([]));
      },
    );
  }
}
