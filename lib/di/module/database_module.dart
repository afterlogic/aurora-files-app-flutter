import 'dart:async';

import 'package:async_injector/async_injector.dart';
import 'package:domain_impl/api/cache/database/local_file_table.dart';
import 'package:domain_impl/api/cache/database/pgp_key_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseModule extends Module<Database> {
  @override
  init(Provider provider) {
    return openDatabase(
      'app_db.sqlite',
      onCreate: onCreate,
      onUpgrade: onUpdate,
      version: dbVersion,
    );
  }

  FutureOr<void> onCreate(Database db, int version) async {
    await PgpKeyTable(db).createTable();
    await LocalFileTable(db).createTable();
  }

  FutureOr<void> onUpdate(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 1:
        {
          return PgpKeyTable(db).createTable();
        }
      case 2:
        {
          final table = PgpKeyTable(db);
          await table.deleteTable();
          return table.createTable();
        }
    }
  }

  static const dbVersion = 3;
}
