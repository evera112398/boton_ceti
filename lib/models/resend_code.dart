import 'package:flutter/material.dart';
import 'dart:async';
import 'package:boton_ceti/global/global_vars.dart';

class ResendCode extends StatefulWidget {
  const ResendCode({super.key});

  @override
  State<ResendCode> createState() => _ResendCodeState();
}

class _ResendCodeState extends State<ResendCode> {
  final List<int> waitTimes = [60, 150, 300];
  int waitingIndex = 0;
  bool canReSend = false;
  late int currentWaitTime;
  Timer? countdownTimer;

  void startTimer() {
    setState(() {
      currentWaitTime = waitTimes[waitingIndex];
    });

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentWaitTime > 0) {
        setState(() {
          currentWaitTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          canReSend = true;
        });
      }
    });
  }

  void resendCode() {
    if (waitingIndex >= waitTimes.length - 1) {
      print('No es posible enviar más sms por el día de hoy.');
      return;
    }
    setState(() {
      canReSend = false;
      waitingIndex++;
    });
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: canReSend ? resendCode : null,
            child: Text(
              'Reenviar código en:',
              style: TextStyle(
                fontFamily: 'Nutmeg',
                fontWeight: FontWeight.w300,
                decoration: TextDecoration.underline,
                color: canReSend
                    ? VariablesGlobales.coloresApp[1]
                    : Colors.grey.shade400,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              formatTime(currentWaitTime),
              style: const TextStyle(
                fontFamily: 'Nutmeg',
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
