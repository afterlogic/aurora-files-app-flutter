class CryptException {
  final String message;

  CryptException(this.message, e, stack) {
    print("encrypt err: $e");
    print("encrypt stack: $stack");
  }
}
