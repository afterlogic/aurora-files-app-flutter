import 'package:domain/api/cache/storage/delegate.dart';

abstract class UserStorageApi {
  Delegate<String> get host;

  Delegate<String> get token;

  Delegate<String> get userEmail;

  Delegate<int> get userId;
}
