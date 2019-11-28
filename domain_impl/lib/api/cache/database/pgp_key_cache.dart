import 'package:dao_wrapped/dao/dao_mixin.dart';
import 'package:domain/api/cache/database/pgp_key_cache_api.dart';
import 'package:domain/model/bd/pgp_key.dart';
import 'package:domain_impl/api/cache/database/pgp_key_table.dart';
import 'package:sqflite/sqlite_api.dart';

class PgpKeyCache with DaoMixin<PgpKey> implements PgpKeyCacheApi {
  @override
  final PgpKeyTable databaseGateway;

  PgpKeyCache(Database database) : databaseGateway = PgpKeyTable(database);

  @override
  Future<List<PgpKey>> getByEmail(String email) {
    return getByField("email", email);
  }
}
