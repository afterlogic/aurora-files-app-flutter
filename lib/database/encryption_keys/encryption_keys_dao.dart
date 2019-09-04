import 'package:aurorafiles/database/encryption_keys/encryption_keys_table.dart';
import 'package:moor_flutter/moor_flutter.dart';

import '../app_database.dart';

part 'encryption_keys_dao.g.dart';

// the _EncryptionKeysDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <AppDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [EncryptionKeys])
class EncryptionKeysDao extends DatabaseAccessor<AppDatabase>
    with _$EncryptionKeysDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  EncryptionKeysDao(AppDatabase db) : super(db);

  Future<List<EncryptionKey>> getEncryptionKeys(String ownersEmail) {
    return (select(encryptionKeys)
          ..where((key) => key.owner.equals(ownersEmail)))
        .get();
  }

  // returns the generated id
  Future<int> addKey(EncryptionKeysCompanion key) {
    return into(encryptionKeys).insert(key);
  }

  Future<int> deleteKeys(List<int> ids) {
    return (delete(encryptionKeys)..where((key) => isIn(key.localId, ids)))
        .go();
  }
}
