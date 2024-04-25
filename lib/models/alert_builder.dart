import 'package:boton_ceti/data/alerts_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertBuilder extends StatefulWidget {
  final Function() callback;
  final AlertData alertData;
  const AlertBuilder({
    super.key,
    required this.alertData,
    required this.callback,
  });

  @override
  State<AlertBuilder> createState() => _AlertBuilderState();
}

class _AlertBuilderState extends State<AlertBuilder> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, ct) {
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.alertData.alertTitle,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'Nutmeg',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Lottie.asset(
                  'assets/lotties/alert.json',
                  fit: BoxFit.cover,
                  animate: true,
                  repeat: true,
                  frameRate: FrameRate(60),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.alertData.alertText,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontFamily: 'Nutmeg',
                                fontWeight: FontWeight.w300,
                                fontSize: constraints.maxHeight * 0.15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      VariablesGlobales.coloresApp[1],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () => widget.callback(),
                                child: const Text(
                                  'Finalizar alerta',
                                  style: TextStyle(
                                    fontFamily: 'Nutmeg',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
