import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'pgp_key_dao.g.dart';

@UseDao(tables: [PgpKey])
class PgpKeyDao extends DatabaseAccessor<AppDatabase> with _$PgpKeyDaoMixin {
  PgpKeyDao(AppDatabase db) : super(db);

  Future<List<LocalPgpKey>> getPublicKey() {
    return (select(pgpKey)..where((key) => key.isPrivate.equals(false))).get();
  }


}
