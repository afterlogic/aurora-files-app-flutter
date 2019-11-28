abstract class Delegate<T> {
  Future set(T value);

  T get();

  Future clear();
}
