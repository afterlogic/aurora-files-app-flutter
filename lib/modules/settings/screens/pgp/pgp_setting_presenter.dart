import 'package:aurorafiles/build_property.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/settings/repository/encryption_local_storage.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_api.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_view.dart';

import 'dialog/create_key_dialog.dart';

class PgpSettingPresenter {
  final PgpSettingView _view;
  final PgpKeyDao _pgpKeyDao;
  final PgpKeyUtil pgpKeyUtil;
  final PgpKeyApi _pgpKeyApi = PgpKeyApi();
  final encryptionStorage = EncryptionLocalStorage.instance;
  bool storePassword;
  List<LocalPgpKey> contactsKey;

  PgpSettingPresenter(this._view, this._pgpKeyDao)
      : pgpKeyUtil = PgpKeyUtil.instance {
    initContactKeys();
  }

  Future refreshKeys(
      [List<LocalPgpKey> addedPublic, List<LocalPgpKey> addedPrivate]) async {
    storePassword = await encryptionStorage.getStorePasswordStorage();
    return _pgpKeyDao.getKeys().then(
      (keys) async {
        final public = addedPublic ?? <LocalPgpKey>[];
        final private = addedPrivate ?? <LocalPgpKey>[];
        keys.forEach((item) {
          if (item.isPrivate) {
            private.add(item);
          } else {
            public.add(item);
          }
        });
        _view.keysState
            .add(KeysState(public, private, contactsKey, storePassword));
      },
      onError: (e) {
        _view.keysState.add(KeysState([], [], contactsKey, storePassword));
      },
    );
  }

  initContactKeys() async {
    contactsKey = await _pgpKeyApi.getKeyFromContacts();
    if (_view.keysState.value is KeysState) {
      _view.keysState.add(KeysState(
        _view.keysState.value.public,
        _view.keysState.value.private,
        contactsKey,
        storePassword,
        _view.keysState.value.isProgress,
      ));
    }
  }

  getKeysFromFile() async {
    final result = await pgpKeyUtil.importKeyFromFile();
    if (result.isNotEmpty) {
      _view.showImportDialog(await _sortKeys(result));
    } else {
      _view.keysNotFound();
    }
  }

  getKeysFromText(String text) async {
    final result = await pgpKeyUtil.validateText(text);

    if (result.isNotEmpty) {
      _view.showImportDialog(await _sortKeys(result));
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

  Future<PgpKeyMap> _sortKeys(
    List<LocalPgpKey> keys,
  ) async {
    final Set<String> userEmail =
        (await AppStore.authState.getIdentity() ?? []).toSet();
    userEmail.add(AppStore.authState.userEmail);
    final userKeys = <LocalPgpKey>[];
    final contactKeys = <LocalPgpKey>[];

    if (BuildProperty.legacyPgpKey) {
      userKeys.addAll(keys);
    } else {
      for (var key in keys) {
        if (userEmail.contains(key.email)) {
          userKeys.add(key);
        } else {
          if (!key.isPrivate) contactKeys.add(key);
        }
      }
    }
    final existUserKeys = await _userKeyMarkIfNotExist(userKeys);
    final existContactKeys = await _contactKeyMarkIfNotExist(contactKeys);

    return PgpKeyMap(existUserKeys, existContactKeys);
  }

  Future<Map<LocalPgpKey, bool>> _userKeyMarkIfNotExist(
      List<LocalPgpKey> keys) async {
    final map = <LocalPgpKey, bool>{};
    for (var key in keys) {
      final existKey = await pgpKeyUtil.checkHasKey(key.email, key.isPrivate);
      map[key] = existKey == false ? true : null;
    }
    return map;
  }

  Future<Map<LocalPgpKey, bool>> _contactKeyMarkIfNotExist(
      List<LocalPgpKey> keys) async {
    final map = <LocalPgpKey, bool>{};
    for (var key in keys) {
      map[key] = true;
    }
    return map;
  }

  Future saveKeys(
      List<LocalPgpKey> userKey, List<LocalPgpKey> contactKey) async {
    await pgpKeyUtil.saveKeys(userKey);
    if (contactKey.isNotEmpty) {
      await _pgpKeyApi.addKeyToContacts(contactKey);
      initContactKeys();
    }
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

    privateKey = privateKey.copyWith(key: keys.privateKey);
    publicKey = publicKey.copyWith(key: keys.publicKey);

    await pgpKeyUtil.saveKeys([publicKey, privateKey]);
    refreshKeys();
  }

  deleteKey(String email) async {
    try {
      await _pgpKeyApi.deleteContactKey(email);
      contactsKey.removeWhere((element) => element.email == email);
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  void setStorePassword(bool value) async {
    await encryptionStorage.setStorePasswordStorage(value);
    refreshKeys();
  }
}
