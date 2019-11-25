abstract class BaseError<T> {
  T errorCase;
  final String description;

  BaseError(this.errorCase, this.description);
}
