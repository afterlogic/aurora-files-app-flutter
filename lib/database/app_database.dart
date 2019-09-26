import 'package:aurorafiles/database/files/files_table.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'app_database.g.dart';

@UseMoor(tables: [Files])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'app_db.sqlite'));

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAllTables();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.addColumn(files, files.guid);
        }
      }
  );

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}
