import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key.dart';
import 'package:aurorafiles/modules/settings/repository/settings_local_storage.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:drift/drift.dart';

part 'pgp_key_dao.g.dart';

@DriftAccessor(tables: [PgpKey])
class PgpKeyDao extends DatabaseAccessor<AppDatabase> with _$PgpKeyDaoMixin {
  final secureStorage = SettingsLocalStorage();

  PgpKeyDao(AppDatabase db) : super(db);

  Future<LocalPgpKey?> getKey(String email, bool isPrivate) async {
    return prepareToLoad(await (select(pgpKey)
          ..where((item) => item.isPrivate.equals(isPrivate))
          ..where((item) => item.email.equals(email)))
        .getSingleOrNull());
  }

  Future<List<LocalPgpKey>> getKeys() async {
    return prepareListToLoad(await select(pgpKey).get());
  }

  Future<List<LocalPgpKey>> getPublicKeys() async {
    return prepareListToLoad(await (select(pgpKey)
          ..where((item) => item.isPrivate.equals(false)))
        .get());
  }

  Future<List<LocalPgpKey>> checkHasKeys(List<LocalPgpKey> keys) async {
    final emails = keys.map((item) => item.email);
    return prepareListToLoad(
        await (select(pgpKey)..where((item) => item.email.isIn(emails))).get());
  }

  Future addKeys(List<LocalPgpKey> keys) async {
    final validKeys = await prepareListToSave(keys);
    for (var key in validKeys) {
      await (delete(pgpKey)
            ..where((item) => item.email.equals(key.email))
            ..where((item) => item.isPrivate.equals(key.isPrivate)))
          .go();
      await into(pgpKey).insert(key.toCompanion(true));
    }
  }

  Future deleteKey(LocalPgpKey key) async {
    return (delete(pgpKey)..where((item) => item.id.equals(key.id))).go();
  }

  Future<bool> checkHasKey(String email, [bool? isPrivate]) {
    final query = select(pgpKey);
    query..where((item) => item.email.equals(email));
    if (isPrivate != null) {
      query..where((item) => item.isPrivate.equals(isPrivate));
    }
    return query.get().then((i) => i.isNotEmpty);
  }

  Future deleteByEmails(List<String> emails) {
    return (delete(pgpKey)..where((item) => item.email.isIn(emails))).go();
  }

  Future<List<LocalPgpKey>> prepareListToSave(List<LocalPgpKey> keys) async {
    final out = <LocalPgpKey>[];
    for (var value in keys) {
      out.add(await prepareToSave(value));
    }
    return out;
  }

  Future<List<LocalPgpKey>> prepareListToLoad(List<LocalPgpKey> keys) async {
    final out = <LocalPgpKey>[];
    for (var value in keys) {
      final key = await prepareToLoad(value);
      if (key != null) out.add(key);
    }
    return out;
  }

  Future<LocalPgpKey> prepareToSave(LocalPgpKey key) async {
    await secureStorage.addKey(key.email + key.isPrivate.toString(), key.key);
    return key.copyWith(key: "");
  }

  Future<LocalPgpKey?> prepareToLoad(LocalPgpKey? key) async {
    if (key?.key.isNotEmpty == true) {
      return key;
    }
    return key?.copyWith(
        key: await secureStorage.getKey(key.email + key.isPrivate.toString()));
  }

  void clear() {
    delete(pgpKey).go();
  }
}
