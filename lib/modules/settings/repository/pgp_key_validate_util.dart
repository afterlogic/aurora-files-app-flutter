import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:crypto_plugin/crypto_plugin.dart';

class PgpKeyValidateUtil {
  final Pgp pgp;
  final PgpKeyDao pgpKeyDao;

  PgpKeyValidateUtil(this.pgp, this.pgpKeyDao);

  Future<List<LocalPgpKey>> validateText(String text) async {
    final keys = RegExp("$keyStart((\D|\d)*)$keyEnd")
        .allMatches(text)
        .map((regExp) => regExp.group(0))
        .toList();

    final localKeys = <LocalPgpKey>[];

    for (String key in keys) {
      final emails = await pgp.getEmailFromKey(key);

      for (String email in emails) {
        final localPgpKey =
            LocalPgpKey(email: email, key: key, isPrivate: false);

        localKeys.add(localPgpKey);
      }
    }

    if (localKeys.isNotEmpty) {
      await pgpKeyDao.addKeys(localKeys);
    }

    return localKeys;
  }

  static const keyStart = "-----BEGIN PGP PUBLIC KEY BLOCK-----";
  static const keyEnd = "-----END PGP PUBLIC KEY BLOCK-----";
}
