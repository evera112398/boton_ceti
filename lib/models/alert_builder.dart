import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertBuilder extends StatefulWidget {
  final String assetPath;
  final String alertTitle;
  final String alertText;
  const AlertBuilder(
      {super.key,
      required this.assetPath,
      required this.alertTitle,
      required this.alertText});

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
                          widget.alertTitle,
                          style: const TextStyle(
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
                color: Colors.purple,
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
                              widget.alertText,
                              style: TextStyle(
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
                                  backgroundColor: Colors.red[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Terminar alerta',
                                  style: TextStyle(
                                    fontFamily: 'Nutmeg',
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
