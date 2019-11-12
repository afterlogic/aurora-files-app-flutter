import 'dart:async';

StreamSubscription<T> listener<T>(Stream<T> stream, onData(T event),
    {Function onError, onDone(), bool cancelOnError}) {
  return stream.listen(
    (v) async {
      try {
        if (onDone is Future Function()) {
          await onData(v);
        } else {
          onData(v);
        }
      } catch (e) {
        onError(e);
      }
    },
    onDone: () async {
      try {
        if (onDone is Future Function()) {
          await onDone();
        } else {
          onDone();
        }
      } catch (e) {
        onError(e);
      }
    },
    onError: onError,
    cancelOnError: cancelOnError,
  );
}
