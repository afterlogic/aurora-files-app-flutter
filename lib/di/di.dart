import 'package:async_injector/async_injector.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/database/files/files_dao.dart';
import 'package:aurorafiles/database/pgp_key/pgp_key_dao.dart';
import 'package:crypto_plugin/crypto_plugin.dart';
import 'package:dio/dio.dart';
import 'package:domain/api/cache/storage/user_storage_api.dart';
import 'package:domain/api/network/auth_network_api.dart';
import 'package:domain_impl/api/cache/storage/user_storage.dart';
import 'package:domain_impl/api/network/auth_network.dart';
import 'package:domain_impl/api/network/dio/dio_instance.dart';
import 'package:domain_impl/api/network/dio/interceptor/auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static Provider instance;

  static T get<T>() => instance.get<T>();

  static init() async {
    final builder = ProviderBuilder();
    //shared_preference
    builder.moduleImpl((_) => SharedPreferences.getInstance());
    builder.moduleImpl<UserStorageApi>(
      (provider) => UserStorage(provider.get()),
    );
    builder.moduleImpl<AuthInterceptor>(
      (provider) => AuthInterceptor(provider.get()),
    );
    builder.moduleImpl<Dio>(
      (provider) => DioInstance.create(provider.get()),
    );
    builder.moduleImpl<AuthNetworkApi>(
      (provider) => AuthNetwork(provider.get()),
    );

    //database
    builder.dependency(AppDatabase());

    builder.moduleImpl((provider) {
      return FilesDao(provider.get());
    });
    builder.moduleImpl((provider) {
      return PgpKeyDao(provider.get());
    });

    //crypto
    builder.dependency(Pgp());

    instance = await builder.build();
  }
}
