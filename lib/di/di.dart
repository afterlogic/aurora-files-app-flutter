import 'package:async_injector/async_injector.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/crypto/aes_crypto_api.dart';
import 'package:domain/api/file_worker/file_worker_api.dart';
import 'package:domain/api/network/auth_network_api.dart';
import 'package:domain/api/network/files_network_api.dart';
import 'package:domain_impl/api/cache/storage/user_storage.dart';
import 'package:domain_impl/api/cryptor/aes_crypto.dart';
import 'package:domain_impl/api/file_worker/file_worker.dart';
import 'package:domain_impl/api/network/auth_network.dart';
import 'package:domain_impl/api/network/dio/dio_instance.dart';
import 'package:domain_impl/api/network/dio/interceptor/auth_interceptor.dart';
import 'package:domain_impl/api/network/files_network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static Provider instance;

  static T get<T>() => instance.get<T>();

  static init() async {
    final builder = ProviderBuilder();
    //shared_preference
    builder.moduleImpl((_) => SharedPreferences.getInstance());
    builder.moduleImpl<UserStorageApi>(
      (p) => UserStorage(p.get()),
    );

    //network
    builder.moduleImpl<AuthInterceptor>(
      (p) => AuthInterceptor(p.get()),
    );
    builder.moduleImpl<Dio>(
      (p) => DioInstance.create(p.get(), p.get()),
    );

    //crypto
    builder.dependency(Pgp());
    builder.dependency(Aes());
    builder.moduleImpl<AesCryptoApi>((p) => AesCrypto(p.get()));

    //database
    builder.dependency(AppDatabase());

    builder.moduleImpl((p) {
      return FilesDao(p.get());
    });
    builder.moduleImpl((p) {
      return PgpKeyDao(p.get());
    });

    //files api
    builder.moduleImpl<FilesNetworkApi>(
      (p) => FilesNetwork(p.get(), p.get()),
    );
    builder.moduleImpl<FileWorkerApi>(
      (p) => FileWorker(p.get(), p.get()),
    );

    //auth api
    builder.moduleImpl<AuthNetworkApi>(
      (p) => AuthNetwork(p.get()),
    );

    instance = await builder.build();
  }
}
