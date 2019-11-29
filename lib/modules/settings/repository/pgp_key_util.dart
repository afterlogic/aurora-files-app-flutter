import 'dart:io';

import 'package:aurorafiles/utils/permissions.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:domain/api/cache/database/pgp_key_cache_api.dart';
import 'package:domain/model/bd/pgp_key.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_extend/share_extend.dart';

class PgpKeyUtil {
  final Pgp pgp;
  final PgpKeyCacheApi pgpKeyDao;

  PgpKeyUtil(this.pgp, this.pgpKeyDao);

  Future<List<PgpKey>> validateText(String text) async {
    final keys = RegExp("$keyStart((\\D|\\d)*)$keyEnd")
        .allMatches(text)
        .map((regExp) => regExp.group(0))
        .toList();
    final localKeys = <PgpKey>[];

    for (String key in keys) {
      final emails = await pgp.getEmailFromKey(key);

      for (String email in emails) {
        final groups = RegExp("(?:\\D|\\d)*<((?:\\D|\\d)*)>").firstMatch(email);
        String validEmail;
        if (groups.groupCount == 1) {
          validEmail = groups.group(1);
        } else {
          validEmail = email;
        }
        final localPgpKey =
            PgpKey.fill(email: validEmail, key: key, isPrivate: false);

        localKeys.add(localPgpKey);
      }
    }

    if (localKeys.isNotEmpty) {
      await pgpKeyDao.setAll(localKeys);
    }

    return localKeys;
  }

  Future<List<PgpKey>> importKeyFromFile() async {
    final File fileWithKey = await FilePicker.getFile();
    if (fileWithKey == null) return null;
    final String contents = await fileWithKey.readAsString();
    return validateText(contents);
  }

  Future<void> shareKeys(String text) async {
    await ShareExtend.share(text, "text");
  }

  Future<String> keysFolder() async {
    final Directory dir = await DownloadsPathProvider.downloadsDirectory;
    return dir.path + pgpKeyPath;
  }

  Future<File> downloadKey(PgpKey key, [String addedPath = ""]) async {
    if (!Platform.isIOS) await getStoragePermissions();
    final file = File(await keysFolder() + addedPath + key.email + ".asc");
    if (await file.exists()) {
      await file.delete();
    }
    await file.create(recursive: true);
    await file.writeAsString(key.key);
    return file;
  }

  Future deleteKey(PgpKey key) async {
    await pgpKeyDao.delete(key.id);
  }

  static const pgpKeyPath = "/pgp_keys/";
  static const keyStart = "-----BEGIN PGP PUBLIC KEY BLOCK-----";
  static const keyEnd = "-----END PGP PUBLIC KEY BLOCK-----";
}
