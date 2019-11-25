abstract class Delegate<T> {
  Future set(T value);

  Future<T> get();

  Future clear();
}
