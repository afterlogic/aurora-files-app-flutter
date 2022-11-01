import 'dart:async';
import 'dart:math';
import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosPressOnKeyDialog extends _IosDialog {
  final Function breaker;

  const IosPressOnKeyDialog(Key? key, this.breaker) : super(key);

  @override
  _IosDialogState createState() => IosPressOnKeyDialogState();
}

class IosPressOnKeyDialogState extends _IosDialogState<IosPressOnKeyDialog> {
  Future success() async {
    setState(() => isSuccess = true);
    await Future.delayed(const Duration(seconds: 2));
    await _animationController.reverse();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Future close(BuildContext context) async {
    if (isSuccess || isClosed) {
      return;
    }
    isClosed = true;
    widget.breaker();
    await _animationController.reverse();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget content(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: KeyedSubtree(
        key: ValueKey(isSuccess),
        child: isSuccess ? _successWidget() : _scanKeyWidget(),
      ),
    );
  }

  Widget _successWidget() {
    final s = context.l10n;
    const size = 115.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Opacity(
          opacity: 0,
          child: Text(
            "Ready to Scan",
            style: TextStyle(
                fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w400),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: SizedBox(
            height: size,
            width: size,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size),
                  border: Border.all(color: const Color(0xFF007bff), width: 6)),
              child: const Center(
                child: Icon(
                  Icons.done_rounded,
                  size: size - 30,
                  color: Color(0xFF007bff),
                ),
              ),
            ),
          ),
        ),
        Text(
          s.fido_label_success,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _scanKeyWidget() {
    const size = 115.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Ready to Scan",
          style: TextStyle(
              fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                border: Border.all(color: const Color(0xFF007bff), width: 6)),
            child: Image.asset(
              Asset.images.useKey,
              width: size,
              height: size,
            ),
          ),
        ),
        const Text(
          "Touch your security key",
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

abstract class _IosDialog extends StatefulWidget {
  const _IosDialog(Key? key) : super(key: key);

  Future show(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => DecoratedBox(
        decoration: const BoxDecoration(color: Colors.black45),
        child: this,
      ),
    );
  }

  @override
  _IosDialogState createState();
}

abstract class _IosDialogState<W extends _IosDialog> extends State<W>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  bool isSuccess = false;
  bool isClosed = false;

  @override
  initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _animationController.forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future close(BuildContext context) async {
    await _animationController.reverse();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.of(context).size;
    final displayHeight = displaySize.height;
    final minSize = displayHeight * 0.75;
    final size = min(min(minSize, displaySize.shortestSide), 500.0);
    return Stack(
      children: [
        Positioned.fill(
          top: null,
          child: Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: size,
                height: size * 0.95,
                margin: const EdgeInsets.all(6),
                padding:
                    const EdgeInsets.symmetric(vertical: 27, horizontal: 35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Material(
                          color: Colors.white,
                          child: Theme(
                            data: ThemeData.light(),
                            child: content(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Opacity(
                      opacity: isSuccess ? 0 : 1,
                      child: IgnorePointer(
                        ignoring: isSuccess,
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.5),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => close(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget content(BuildContext context);
}
