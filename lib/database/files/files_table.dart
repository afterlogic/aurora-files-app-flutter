import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("LocalFile")
class Files extends Table {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get id => text()();

  TextColumn get type => text()();

  TextColumn get path => text()();

  TextColumn get fullPath => text()();

  TextColumn get name => text()();

  IntColumn get size => integer()();

  BoolColumn get isFolder => boolean()();

  BoolColumn get isLink => boolean()();

  TextColumn get linkType => text()();

  TextColumn get linkUrl => text()();

  IntColumn get lastModified => integer()();

  TextColumn get contentType => text()();

  TextColumn get oEmbedHtml => text()();

  BoolColumn get published => boolean()();

  TextColumn get owner => text()();

  TextColumn get content => text()();

  TextColumn get viewUrl => text()();

  TextColumn get downloadUrl => text()();

  TextColumn get thumbnailUrl => text()();

  TextColumn get hash => text()();

  TextColumn get extendedProps => text()();

  BoolColumn get isExternal => boolean()();

  TextColumn get initVector => text()();
}
