import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:injector/injector.dart';
import 'package:crypto_plugin/crypto_plugin.dart';

class DI {
  static Injector instance;

  static T get<T>() => instance.getDependency<T>();

  static init() {
    instance = Injector();
    instance.registerDependency<AppDatabase>((_) {
      return AppDatabase();
    });
    instance.registerDependency<FilesDao>((inj) {
      return FilesDao(inj.getDependency());
    });
    instance.registerDependency<PgpKeyDao>((inj) {
      return PgpKeyDao(inj.getDependency());
    });

    instance.registerDependency<Pgp>((_) {
      return Pgp();
    });
  }
}
