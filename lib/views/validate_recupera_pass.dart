import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/helpers/rebuild_ui.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:boton_ceti/models/otp_square.dart';
import 'package:boton_ceti/models/resend_code.dart';
import 'package:boton_ceti/views/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ValidateRecuperaPass extends StatefulWidget {
  final int idUsuario;
  final String correo;
  const ValidateRecuperaPass(
      {super.key, required this.idUsuario, required this.correo});

  @override
  State<ValidateRecuperaPass> createState() => _ValidateRecuperaPassState();
}

class _ValidateRecuperaPassState extends State<ValidateRecuperaPass> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  bool hasError = false;
  final List<TextEditingController> emailValidatorOTP = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> emailValidatorFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget errorContent(String errorMessage) {
    hasError = true;
    RebuildUI.rebuild(context, setState);
    return ErrorPopupContent(
      error: errorMessage,
    );
  }

  Widget successContent() {
    hasError = false;
    RebuildUI.rebuild(context, setState);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Lottie.asset(
                  'assets/lotties/success.json',
                  fit: BoxFit.cover,
                  frameRate: FrameRate(60),
                  animate: true,
                  repeat: false,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.33,
                      width: constraints.maxWidth * 0.75,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Código validado con éxito.',
                          style: TextStyle(
                            fontFamily: 'Nutmeg',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> validateEmailCode() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    String finalCode = '';
    for (var code in emailValidatorOTP) {
      finalCode += code.text;
    }
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    final response =
        await singletonProvider.usuariosController.validaRecuperarPass(
      finalCode,
      widget.idUsuario,
    );
    Future.microtask(
      () => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: width,
                  child: !response['ok']
                      ? errorContent(response['payload'])
                      : successContent(),
                );
              },
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: VariablesGlobales.coloresApp[1],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (!hasError) {
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) {
                        Navigator.of(context).push(
                          crearRutaNamed(
                              ChangePasswordView(
                                codigo: finalCode,
                                idUsuario: widget.idUsuario,
                              ),
                              'changePassword'),
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    fontFamily: 'Nutmeg',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            setState(() {
              Future.microtask(() => currentFocus.unfocus());
            });
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              height: constraints.maxWidth * 0.18,
              width: constraints.maxWidth * 0.18,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: validateEmailCode,
                  elevation: 5,
                  backgroundColor: VariablesGlobales.coloresApp[1],
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const Expanded(
                  flex: 1,
                  child: AppBanner(),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: const FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Validar correo electrónico',
                                style: TextStyle(
                                  fontFamily: 'Nutmeg',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
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
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: const Text(
                                'Ingresa el código de un sólo uso que hemos enviado a tu correo electrónico',
                                style: TextStyle(
                                  fontFamily: 'Nutmeg',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        width: double.infinity,
                        child: Form(
                          key: _keyForm,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: OTPSquare(
                                  isFirst: true,
                                  canGoBack: false,
                                  controller: emailValidatorOTP[0],
                                  focusNode: emailValidatorFocusNodes[0],
                                ),
                              ),
                              const SizedBox(width: 1),
                              Expanded(
                                child: OTPSquare(
                                  controller: emailValidatorOTP[1],
                                  focusNode: emailValidatorFocusNodes[1],
                                ),
                              ),
                              const SizedBox(width: 1),
                              Expanded(
                                child: OTPSquare(
                                  controller: emailValidatorOTP[2],
                                  focusNode: emailValidatorFocusNodes[2],
                                ),
                              ),
                              const SizedBox(width: 1),
                              Expanded(
                                child: OTPSquare(
                                  controller: emailValidatorOTP[3],
                                  focusNode: emailValidatorFocusNodes[3],
                                ),
                              ),
                              const SizedBox(width: 1),
                              Expanded(
                                child: OTPSquare(
                                  controller: emailValidatorOTP[4],
                                  focusNode: emailValidatorFocusNodes[4],
                                ),
                              ),
                              const SizedBox(width: 1),
                              Expanded(
                                child: OTPSquare(
                                  isLast: true,
                                  controller: emailValidatorOTP[5],
                                  focusNode: emailValidatorFocusNodes[5],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ResendCode(
                        valor: widget.correo,
                        tipo: 'Correo',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
