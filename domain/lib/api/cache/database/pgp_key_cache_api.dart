import 'package:domain/model/pgp_key.dart';

abstract class PgpKeyCacheApi {
  Future<List<PgpKey>> getPublicKeys();

  Future setAll(List<PgpKey> keys);

  Future delete(String id);
}
