import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ResendCode extends StatefulWidget {
  final String tipo;
  final String valor;
  const ResendCode({super.key, required this.valor, required this.tipo});

  @override
  State<ResendCode> createState() => _ResendCodeState();
}

class _ResendCodeState extends State<ResendCode> {
  final List<int> waitTimes = [60, 150, 300];
  int waitingIndex = 0;
  bool canReSend = false;
  late int currentWaitTime;
  Timer? countdownTimer;
  late ControllersProvider singletonProvider;
  late FToast fToast;

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
    assignProvider();
    startTimer();
  }

  Future<void> assignProvider() async {
    singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    setState(() {});
  }

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

  _showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey.shade300,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VariablesGlobales.coloresApp[1].withOpacity(0.7),
              ),
              child: Image.asset(
                'assets/images/castor.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            flex: 4,
            child: Text(
              message,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  Future<void> resendCode() async {
    if (waitingIndex >= waitTimes.length - 1) {
      _showToast('Has alcanzado el máximo de intentos posibles.');
      return;
    }

    final response = widget.tipo == 'Correo'
        ? await singletonProvider.usuariosController
            .sendCodigoValidacionCorreo(widget.valor)
        : await singletonProvider.usuariosController
            .sendCodigoValidacionCelular(widget.valor);
    if (!response['ok']) {
      if (!mounted) return;
      _showToast(response['payload']);
      return;
    }
    _showToast('${widget.tipo} enviado con éxito.');
    setState(() {
      canReSend = false;
      waitingIndex++;
    });
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
            // onTap: canReSend ? resendCode : null,
            onTap: resendCode,
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
