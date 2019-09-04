import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/encryption_keys/encryption_keys_dao.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'settings_state.g.dart';

class SettingsState = _SettingsState with _$SettingsState;

abstract class _SettingsState with Store {
  final _settingsLocal = SettingsLocalStorage();
  final _encryptionKeysDao = EncryptionKeysDao(AppStore.appDb);

  @observable
  bool isParanoidEncryptionEnabled = false;

  @observable
  String encryptionKeyName;

  @observable
  String encryptionKey;

  void onGenerateEncryptionKey({
    @required String name,
    @required String password,
  }) {
    final key = _settingsLocal.generateKey();
    final newKey = new EncryptionKeysCompanion(
      name: Value(name),
      key: Value(key.base16),
      owner: Value(AppStore.authState.userEmail),
    );
    _encryptionKeysDao.addKey(newKey);
  }
}
