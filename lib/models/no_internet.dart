import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetPopup extends StatelessWidget {
  final Function() callback;
  const NoInternetPopup({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            var height = MediaQuery.of(context).size.height;
            return SizedBox(
              height: height * 0.25,
              width: width,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Lottie.asset(
                            'assets/lotties/alert.json',
                            fit: BoxFit.cover,
                            frameRate: FrameRate(60),
                            animate: true,
                            repeat: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 1,
                        child: LayoutBuilder(
                          builder: (context, constraints) => const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No cuentas con conexión a internet, favor de revisar tu conexión para poder emitir alertas.',
                                style: TextStyle(
                                  fontFamily: 'Nutmeg',
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          },
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: VariablesGlobales.coloresApp[1]),
            onPressed: callback,
            child: const Text(
              'Reintentar',
              style: TextStyle(
                fontFamily: 'Nutmeg',
              ),
            ),
          )
        ],
      ),
    );
  }
}
