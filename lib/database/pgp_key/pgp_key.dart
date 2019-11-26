import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("LocalPgpKey")
class PgpKey extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer().autoIncrement()();

  TextColumn get email => text()();

  TextColumn get key => text()();

  BoolColumn get isPrivate => boolean()();

  IntColumn get length => integer().nullable()();
}
