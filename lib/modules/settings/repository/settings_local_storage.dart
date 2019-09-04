import 'package:encrypt/encrypt.dart';

class SettingsLocalStorage {
  Key generateKey() => Key.fromSecureRandom(32);
}
