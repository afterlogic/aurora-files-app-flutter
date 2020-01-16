import 'dart:io';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/utils/permissions.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class PgpKeyUtil {
  final Pgp pgp;
  final PgpKeyDao pgpKeyDao;

  PgpKeyUtil(this.pgp, this.pgpKeyDao);

  Future<List<LocalPgpKey>> validateText(String text) async {
    final keys = RegExp("$keyStart((\\D|\\d)*)$keyEnd")
        .allMatches(text)
        .map((regExp) => regExp.group(0))
        .toList();
    final localKeys = <LocalPgpKey>[];

    for (String key in keys) {
      final description = await pgp.getKeyDescription(key);

      for (String email in description.email) {
        final groups = RegExp("(?:\\D|\\d)*<((?:\\D|\\d)*)>").firstMatch(email);
        String validEmail;
        if (groups.groupCount == 1) {
          validEmail = groups.group(1);
        } else {
          validEmail = email;
        }
        final localPgpKey = LocalPgpKey(
            email: validEmail,
            key: key,
            isPrivate: description.isPrivate,
            length: description.length);

        localKeys.add(localPgpKey);
      }
    }

    return localKeys;
  }

  Future<LocalPgpKey> userPrivateKey() {
    return pgpKeyDao.getKey(AppStore.authState.userEmail, true);
  }
  Future<LocalPgpKey> userPublicKey() {
    return pgpKeyDao.getKey(AppStore.authState.userEmail, false);
  }

  saveKeys(List<LocalPgpKey> keys) async {
    await pgpKeyDao.addKeys(keys);
  }

  Future<List<LocalPgpKey>> checkHasKeys(List<LocalPgpKey> keys) {
    return pgpKeyDao.checkHasKeys(keys);
  }

  Future<bool> checkHasKey(String email) {
    return pgpKeyDao.checkHasKey(email);
  }

  Future deleteByEmail(List<String> emails) {
    return pgpKeyDao.deleteByEmails(emails);
  }

  Future<List<LocalPgpKey>> importKeyFromFile() async {
    final File fileWithKey = await FilePicker.getFile();
    if (fileWithKey == null) return null;
    final String contents = await fileWithKey.readAsString();
    return validateText(contents);
  }

  Future<void> shareKeys(String text) async {
    await ShareExtend.share(text, "text");
  }

  Future<String> keysFolder() async {
    final Directory dir =
        (await getExternalStorageDirectories(type: StorageDirectory.downloads))
            .first;
    return dir.path + pgpKeyPath;
  }

  Future<File> downloadKey(LocalPgpKey key, [String addedPath = ""]) async {
    if (!Platform.isIOS) await getStoragePermissions();
    final file = File(await keysFolder() + addedPath + key.email + ".asc");
    if (await file.exists()) {
      await file.delete();
    }
    await file.create(recursive: true);
    await file.writeAsString(key.key);
    return file;
  }

  Future<File> downloadKeys(List<LocalPgpKey> keys,
      [String addedPath = ""]) async {
    if (!Platform.isIOS) await getStoragePermissions();
    final file = File(await keysFolder() + addedPath + "export_keys" + ".asc");
    if (await file.exists()) {
      await file.delete();
    }
    await file.create(recursive: true);
    for (LocalPgpKey key in keys) {
      await file.writeAsString(key.key, mode: FileMode.append);
    }
    return file;
  }

  Future deleteKey(LocalPgpKey key) async {
    await pgpKeyDao.deleteKey(key);
  }

  Future<KeyPair> createKeys(int length, String email, String password) async {
    await pgp.stop();
    return pgp.createKeys(length, email, password);
  }

  Future<bool> checkPrivateKey(String password, String pgpKey) {
    return pgp.checkPassword(password, pgpKey);
  }

  static const pgpKeyPath = "/pgp_keys/";
  static const keyStart = "-----BEGIN PGP \\w* KEY BLOCK-----";
  static const keyEnd = "-----END PGP \\w* KEY BLOCK-----";

  close() {
    pgp.stop();
  }
}
