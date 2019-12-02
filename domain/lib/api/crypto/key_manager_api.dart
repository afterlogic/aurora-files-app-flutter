abstract class KeyManagerApi {
  Future createKey(String keyName);

  Future addKey(String keyName, String key);

  Future<String> getKey(String keyName);

  Future deleteKey(keyName);

  Future<Map<String, String>> getAllKeys();
}
