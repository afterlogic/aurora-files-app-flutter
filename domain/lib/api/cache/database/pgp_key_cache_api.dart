import 'package:domain/model/bd/pgp_key.dart';

abstract class PgpKeyCacheApi {
  Future<List<PgpKey>> getPublicKeys();

  Future setAll(List<PgpKey> keys);

  Future delete(String id);
}
