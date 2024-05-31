import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/helpers/rebuild_ui.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:boton_ceti/views/validate_recupera_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SendRecuperaPassCode extends StatefulWidget {
  final String usuario;
  final String celular;
  const SendRecuperaPassCode({
    super.key,
    required this.usuario,
    required this.celular,
  });

  @override
  State<SendRecuperaPassCode> createState() => _SendRecuperaPassCodeState();
}

class _SendRecuperaPassCodeState extends State<SendRecuperaPassCode> {
  bool succesfullySent = true;
  @override
  Widget build(BuildContext context) {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async => false,
      child: StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          contentPadding: EdgeInsets.zero,
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
              return Container(
                clipBehavior: Clip.hardEdge,
                constraints: BoxConstraints(
                  minHeight: height * 0.2,
                  maxHeight: height * 0.3,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: width,
                child: FutureBuilder(
                  future: Future.delayed(
                    const Duration(seconds: 2),
                  ).then(
                    (value) =>
                        singletonProvider.usuariosController.recuperarPass(
                      widget.celular,
                      widget.usuario,
                    ),
                  ),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      succesfullySent = false;
                      RebuildUI.rebuild(context, setState);
                      return const ErrorPopupContent(
                        error: 'Sucedió un error inesperado.',
                      );
                    }
                    if (snapshot.hasData) {
                      if (!snapshot.data['ok']) {
                        succesfullySent = false;
                        RebuildUI.rebuild(context, setState);
                        return ErrorPopupContent(
                            error: snapshot.data['payload']);
                      }
                      Navigator.of(context).pop();

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).push(
                          crearRutaNamed(
                            ValidateRecuperaPass(
                              idUsuario: snapshot.data['payload'],
                              correo: widget.usuario,
                            ),
                            'sendRecuperaPassCode',
                          ),
                        );
                      });
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: VariablesGlobales.coloresApp[1],
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
          actions: succesfullySent
              ? null
              : [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VariablesGlobales.coloresApp[1],
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        fontFamily: 'Nutmeg',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}

  // Future<void> sendValidationCode() async {
  //   final singletonProvider =
  //       Provider.of<ControllersProvider>(context, listen: false);
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (timeStamp) {
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return WillPopScope(
  //             onWillPop: () async => false,
  //             child: VariableFutureBuilder(
  //               future: Future.delayed(const Duration(seconds: 2)).then(
  //                 (value) => singletonProvider.usuariosController
  //                     .sendCodigoValidacionCorreo(
  //                   emailController.text,
  //                 ),
  //               ),
  //               nextScreen: const ValidateEmail(),
  //               nextScreenName: 'validateEmail',
  //               actions: [
  //                 ElevatedButton(
  //                   onPressed: () => Navigator.of(context).pop(),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: VariablesGlobales.coloresApp[1],
  //                   ),
  //                   child: const Text(
  //                     'Aceptar',
  //                     style: TextStyle(
  //                       fontFamily: 'Nutmeg',
  //                       fontWeight: FontWeight.w300,
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }