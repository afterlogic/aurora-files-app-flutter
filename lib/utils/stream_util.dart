import 'dart:async';

StreamSubscription<T> listener<T>(
  Stream<T> stream,
  onData(T event), {
  Function? onError,
  Function? onDone,
  bool? cancelOnError,
}) {
  return stream.listen(
    (v) async {
      try {
        if (onData is Future Function()) {
          await onData(v);
        } else {
          onData(v);
        }
      } catch (e) {
        if (onError != null) onError(e);
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
      } catch (e) {
        if (onError != null) onError(e);
      }
    },
    onError: onError,
    cancelOnError: cancelOnError,
  );
}
