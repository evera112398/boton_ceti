import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorPopupContent extends StatelessWidget {
  final String error;
  const ErrorPopupContent({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.5,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/lotties/error.json',
                    animate: true,
                    frameRate: FrameRate(60),
                    repeat: false,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: const Text(
                          'Error',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nutmeg',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Nutmeg',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
