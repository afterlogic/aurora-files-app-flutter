import 'package:dao_wrapped/table/database_gateway.dart';
import 'package:domain/model/bd/local_file.dart';
import 'package:sqflite/sqlite_api.dart';

class LocalFileTable extends DatabaseGateway<LocalFile> {
  @override
  final Database db;

  LocalFileTable(this.db);

  @override
  Future createTable() {
    var createTableRequest = "CREATE TABLE IF NOT EXISTS $table("
        "$primaryId INTEGER PRIMARY KEY,"
        "id TEXT,"
        "guid TEXT,"
        "type TEXT,"
        "path TEXT,"
        "fullPath TEXT,"
        "localPath TEXT,"
        "name TEXT,"
        "size INTEGER,"
        "isFolder BLOB,"
        "isOpenable BLOB,"
        "isLink BLOB,"
        "linkType TEXT,"
        "linkUrl TEXT,"
        "lastModified INTEGER,"
        "contentType TEXT,"
        "oEmbedHtml TEXT,"
        "published BLOB,"
        "owner TEXT,"
        "content TEXT,"
        "viewUrl TEXT,"
        "downloadUrl TEXT,"
        "thumbnailUrl TEXT,"
        "hash TEXT,"
        "extendedProps TEXT,"
        "isExternal BLOB,"
        "initVector TEXT)";

    print(createTableRequest);
    return db.execute(createTableRequest);
  }

  @override
  String get primaryId => "localId";

  @override
  String get table => "LocalFile";

  @override
  LocalFile fromMap(Map<String, dynamic> map) {
    return LocalFile.fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(LocalFile model) {
    return model.toJson();
  }
}
