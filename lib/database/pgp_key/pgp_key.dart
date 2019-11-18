import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("LocalPgpKey")
class PgpKey extends Table {
   TextColumn get email => text()();

  TextColumn get key => text()();

  BoolColumn get isPrivate => boolean()();
}
