import 'package:moor_flutter/moor_flutter.dart';

class Files extends Table {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get Id => text()();

  TextColumn get Type => text()();

  TextColumn get Path => text()();

  TextColumn get FullPath => text()();

  TextColumn get Name => text()();

  IntColumn get Size => integer()();

  BoolColumn get IsFolder => boolean()();

  BoolColumn get IsLink => boolean()();

  TextColumn get LinkType => text()();

  TextColumn get LinkUrl => text()();

  IntColumn get LastModified => integer()();

  TextColumn get ContentType => text()();

  BoolColumn get Thumb => boolean()();

  TextColumn get ThumbnailLink => text()();

  TextColumn get OembedHtml => text()();

  BoolColumn get Shared => boolean()();

  TextColumn get Owner => text()();

  TextColumn get Content => text()();

  TextColumn get ViewUrl => text()();

  TextColumn get DownloadUrl => text()();

  TextColumn get ThumbnailUrl => text()();

  TextColumn get Hash => text()();

  BoolColumn get IsExternal => boolean()();
}
