import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("LocalPgpKey")
class PgpKey extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get email => text()();

  TextColumn get key => text()();

  BoolColumn get isPrivate => boolean()();

  IntColumn get length => integer().nullable()();

  TextColumn get name => text()();
}
