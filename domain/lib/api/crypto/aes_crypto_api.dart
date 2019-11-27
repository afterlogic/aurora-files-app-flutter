abstract class AesCryptoApi {
  Stream<List<int>> encryptStream(
    Stream<List<int>> stream,
    String encryptKey,
    String iv,
    int vectorLength,
    Function(String) onLastVector,
  );

  Stream<List<int>> decryptStream(
    Stream<List<int>> stream,
    String encryptKey,
    String iv,
    int vectorLength,
    Function(String) onLastVector,
  );
}
