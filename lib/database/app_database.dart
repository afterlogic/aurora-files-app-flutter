import 'package:aurorafiles/database/files/files_table.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'app_database.g.dart';

@UseMoor(tables: [Files, PgpKey])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'app_db.sqlite'));

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAllTables();
      }, onUpgrade: (Migrator m, int from, int to) async {
        for (int current = from; current < to; current++) {
          switch (current) {
            case 0:
              {
                await m.addColumn(files, files.guid);
                break;
              }
            case 1:
              {
                await m.createTable(pgpKey);
                break;
              }
            case 2:
              {
                await m.deleteTable(pgpKey.tableName);
                await m.createTable(pgpKey);
                break;
              }
          }
        }
      });

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 3;
}
