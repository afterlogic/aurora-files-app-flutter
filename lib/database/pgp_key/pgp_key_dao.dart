import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'pgp_key_dao.g.dart';

@UseDao(tables: [PgpKey])
class PgpKeyDao extends DatabaseAccessor<AppDatabase> with _$PgpKeyDaoMixin {
  PgpKeyDao(AppDatabase db) : super(db);

  Future<List<LocalPgpKey>> getKeys() {
    return select(pgpKey).get();
  }

  Future<List<LocalPgpKey>> checkHasKeys(List<LocalPgpKey> keys) {
    final emails = keys.map((item) => item.email);
    return (select(pgpKey)
      ..where((item) => isIn(item.email, emails))).get();
  }

  Future addKeys(List<LocalPgpKey> keys) async {
    final emails = keys.map((item) => item.email);
    await (delete(pgpKey)
      ..where((item) => isIn(item.email, emails))).go();
    return into(pgpKey).insertAll(keys);
  }

  Future deleteKey(LocalPgpKey key) async {
    return (delete(pgpKey)
      ..where((item) => item.id.equals(key.id))).go();
  }

  Future<bool> checkHasKey(String email) {
    return (select(pgpKey)
      ..where((item) => item.email.equals(email)))
        .get()
        .then((i) => i.isNotEmpty);
    }
}
