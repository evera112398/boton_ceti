import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/otp_square.dart';
import 'package:flutter/material.dart';

class ValidateEmail extends StatefulWidget {
  const ValidateEmail({super.key});

  @override
  State<ValidateEmail> createState() => _ValidateEmailState();
}

class _ValidateEmailState extends State<ValidateEmail> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
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

  Future<void> validateEmailCode() async {
    Navigator.of(context).pop(true);
    // if (_keyForm.currentState!.validate()) {
    //   print('Validado');
    // } else {
    //   print('Hay un error');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
