import 'package:moor_flutter/moor_flutter.dart';

import '../app_database.dart';
import 'files_table.dart';

part 'files_dao.g.dart';

// the _FilesDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <AppDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [Files])
class FilesDao extends DatabaseAccessor<AppDatabase> with _$FilesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  FilesDao(AppDatabase db) : super(db);

  Future<List<LocalFile>> getFiles(String ownersEmail) {
    return (select(files)..where((file) => file.owner.equals(ownersEmail)))
        .get();
  }

  // returns the generated id
  Future<int> addFile(FilesCompanion key) {
    return into(files).insert(key);
  }

  Future<int> deleteFiles(List<int> ids) {
    return (delete(files)..where((file) => isIn(file.localId, ids))).go();
  }
}
