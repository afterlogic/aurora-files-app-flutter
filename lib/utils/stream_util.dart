import 'dart:async';

StreamSubscription<T> listener<T>(
  Stream<T> stream,
  Function(T) onData, {
  Function? onError,
  Function? onDone,
  bool? cancelOnError,
}) {
  return stream.listen(
    (value) async {
      try {
        if (onData is Future Function()) {
          await onData(value);
        } else {
          onData(value);
        }
      } catch (err) {
        if (onError != null) onError(err);
      }
    },
    onDone: () async {
      if (onDone == null) return;
      try {
        if (onDone is Future Function()) {
          await onDone();
        } else {
          onDone();
        }
      } catch (err) {
        if (onError != null) onError(err);
      }
    },
    onError: onError,
    cancelOnError: cancelOnError,
  );
}
