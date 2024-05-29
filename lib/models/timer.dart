import 'dart:async';

import 'package:flutter/material.dart';

class RedirectTimer extends StatefulWidget {
  final int seconds;
  final Function() callback;
  const RedirectTimer(
      {super.key, required this.seconds, required this.callback});

  @override
  State<RedirectTimer> createState() => _RedirectTimerState();
}

class _RedirectTimerState extends State<RedirectTimer> {
  late int _seconds;
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _timer?.cancel();
        widget.callback();
      } else {
        _seconds--;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _seconds = widget.seconds;
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _seconds.toString(),
      style: const TextStyle(
        fontFamily: 'Nutmeg',
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
