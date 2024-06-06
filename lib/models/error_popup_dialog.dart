import 'package:boton_ceti/models/dynamic_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ExceptionPopupDialog extends StatefulWidget {
  final String title;
  final String exceptionDescription;
  final String? jsonLottiePath;
  final List<Widget>? actions;
  const ExceptionPopupDialog({
    super.key,
    required this.title,
    required this.exceptionDescription,
    this.jsonLottiePath,
    this.actions,
  });

  @override
  State<ExceptionPopupDialog> createState() => _ExceptionPopupDialogState();
}

class _ExceptionPopupDialogState extends State<ExceptionPopupDialog> {
  @override
  Widget build(BuildContext context) {
    return DynamicAlertDialog(
      givedHeight: MediaQuery.of(context).size.height * 0.4,
      actions: widget.actions,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            widget.jsonLottiePath ?? 'assets/lotties/question.json',
            animate: true,
            reverse: false,
            repeat: false,
            frameRate: FrameRate(60),
            fit: BoxFit.contain,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Nutmeg',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    widget.exceptionDescription,
                    style: const TextStyle(
                      fontFamily: 'Nutmeg',
                      fontWeight: FontWeight.w300,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
