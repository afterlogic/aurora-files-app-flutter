import 'package:dao_wrapped/table/database_gateway.dart';
import 'package:domain/model/bd/pgp_key.dart';
import 'package:sqflite/sqlite_api.dart';

class PgpKeyTable extends DatabaseGateway<PgpKey> {
  @override
  final Database db;

  PgpKeyTable(this.db);

  @override
  Future createTable() {
    var createTableRequest = "CREATE TABLE IF NOT EXISTS $table("
        "$primaryId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "email TEXT,"
        "key TEXT,"
        "isPrivate BLOB)";

    print(createTableRequest);
    return db.execute(createTableRequest);
  }

  Future deleteTable() {
    var deleteTableRequest = "DROP TABLE IF EXISTS $table";
    print(deleteTableRequest);
    return db.execute(deleteTableRequest);
  }

  @override
  String get primaryId => "id";

  @override
  String get table => "PgpKey";

  @override
  PgpKey fromMap(Map<String, dynamic> map) {
    return PgpKey.fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(PgpKey model) {
    return model.toJson();
  }
}
