import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("EncryptionKey")
class EncryptionKeys extends Table {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1)();

  TextColumn get key => text().withLength(min: 64, max: 64)();

  TextColumn get owner => text()();
}
