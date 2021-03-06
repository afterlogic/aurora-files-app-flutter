import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("LocalFile")
class Files extends Table {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get id => text()();

  TextColumn get guid => text().nullable()();

  TextColumn get type => text()();

  TextColumn get path => text()();

  TextColumn get fullPath => text()();

  TextColumn get localPath => text()();

  TextColumn get name => text()();

  IntColumn get size => integer()();

  BoolColumn get isFolder => boolean()();

  BoolColumn get isOpenable => boolean()();

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

  TextColumn get thumbnailUrl => text().nullable()();

  TextColumn get hash => text()();

  TextColumn get extendedProps => text()();

  BoolColumn get isExternal => boolean()();

  TextColumn get initVector => text().nullable()();

  TextColumn get linkPassword => text().nullable()();

  TextColumn get encryptedDecryptionKey => text().nullable()();

}
