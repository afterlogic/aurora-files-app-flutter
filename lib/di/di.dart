import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_plugin/crypto_plugin.dart';

class DI {
  static GetIt instance;

  static T get<T>() => instance.get<T>();

  static init() {
    instance = GetIt.instance;

    instance.registerSingleton<AppDatabase>(AppDatabase());
    instance.registerSingleton<FilesDao>(FilesDao(get()));
    instance.registerSingleton<PgpKeyDao>(PgpKeyDao(get()));
    instance.registerSingleton<Pgp>(Pgp());
    instance.registerSingleton<Aes>(Aes());
  }
}
