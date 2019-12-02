import 'package:async_injector/async_injector.dart';
import 'package:aurorafiles/di/module/database_module.dart';
import 'package:aurorafiles/ui/navigator/app_navigator.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:dio/dio.dart';
import 'package:domain/api/cache/database/local_file_cache_api.dart';
import 'package:domain/api/cache/database/pgp_key_cache_api.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/crypto/aes_crypto_api.dart';
import 'package:domain/api/file_worker/file_load_worker_api.dart';
import 'package:domain/api/network/auth_network_api.dart';
import 'package:domain/api/network/files_network_api.dart';
import 'package:domain_impl/api/cache/database/local_file_cache.dart';
import 'package:domain_impl/api/cache/database/pgp_key_cache.dart';
import 'package:domain_impl/api/cache/storage/user_storage.dart';
import 'package:domain_impl/api/cryptor/aes_crypto.dart';
import 'package:domain_impl/api/file_worker/file_load_worker.dart';
import 'package:domain_impl/api/network/auth_network.dart';
import 'package:domain_impl/api/network/dio/dio_instance.dart';
import 'package:domain_impl/api/network/dio/interceptor/auth_interceptor.dart';
import 'package:domain_impl/api/network/files_network.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static Provider instance;

  static T get<T>() => instance.get<T>();

  static bool get isInit => instance != null;

  static Future init() async {
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
    builder.module(DatabaseModule());
    builder.moduleImpl<LocalFileCacheApi>((p) {
      return LocalFileCache(p.get(), p.get());
    });
    builder.moduleImpl<PgpKeyCacheApi>((p) {
      return PgpKeyCache(p.get());
    });

    //files api
    builder.moduleImpl<FilesNetworkApi>(
      (p) => FilesNetwork(p.get(), p.get()),
    );
    builder.moduleImpl<FileLoadWorkerApi>(
      (p) => FileLoadWorker(p.get(), p.get()),
    );

    //auth api
    builder.moduleImpl<AuthNetworkApi>(
      (p) => AuthNetwork(p.get()),
    );

    instance = await builder.build();
  }
}
