import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AlertEndBody extends StatefulWidget {
  const AlertEndBody({super.key});

  @override
  State<AlertEndBody> createState() => _AlertEndBodyState();
}

class _AlertEndBodyState extends State<AlertEndBody> {
  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                height: height * 0.3,
                width: width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Lottie.asset(
                              'assets/lotties/question.json',
                              fit: BoxFit.contain,
                              frameRate: FrameRate(60),
                              animate: true,
                              repeat: false,
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Esta información es proporcionada con fines informativos referentes a la cuenta con la que te registraste.\nConsérvalos para cualquier aclaración futura.',
                                  style: TextStyle(
                                    fontFamily: 'Nutmeg',
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Datos del usuario:',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Nombre completo:',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  '${LocalStorage.nombre} ${LocalStorage.apellidoPaterno} ${LocalStorage.apellidoMaterno}',
                  style: const TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Correo electrónico:',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  '${LocalStorage.correo}',
                  style: const TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Teléfono',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  '${LocalStorage.celular}',
                  style: const TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Fecha:',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  getCurrentDate(),
                  style: const TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Folio:',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  'T000001',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: GestureDetector(
                  onTap: showAboutDialog,
                  child: Text(
                    '¿Para qué me sirve esta información?',
                    style: TextStyle(
                      color: VariablesGlobales.coloresApp[1],
                      fontFamily: 'Nutmeg',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
