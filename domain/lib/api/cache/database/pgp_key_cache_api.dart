import 'package:domain/model/bd/pgp_key.dart';

abstract class PgpKeyCacheApi {
  Future<List<PgpKey>> getAll();

  Future setAll(List<PgpKey> keys);

  Future<List<PgpKey>> getByEmail(String email);

  Future delete(String id);
}
