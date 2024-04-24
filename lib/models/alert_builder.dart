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
                      child: Container(
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
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(widget.assetPath),
                          ),
                          Lottie.asset(
                            'assets/lotties/ripple_effect.json',
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    child: Column(
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
                    ),
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
