import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ToastWidget extends StatefulWidget {
  final Duration duration;

  const ToastWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  ToastWidgetState createState() => ToastWidgetState();
}

class ToastWidgetState extends State<ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _animation;
  late Subject<String> _queue;
  Widget? _toast;

  @override
  void initState() {
    _queue = BehaviorSubject<String>();
    _animation = AnimationController(vsync: this, duration: widget.duration);
    super.initState();

    _queue.asyncMap((message) {
      return _show(message);
    }).listen((_) {});
  }

  show(String message) {
    _queue.add(message);
  }

  _show(String message) async {
    _toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
    await _animation.forward(from: 0);
    await Future.delayed(const Duration(seconds: 3));
    await _animation.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        if (value == 0 || _toast == null) {
          return const SizedBox(
            height: 20,
          );
        }
        return Opacity(
          opacity: value,
          child: _toast,
        );
      },
    );
  }
}
