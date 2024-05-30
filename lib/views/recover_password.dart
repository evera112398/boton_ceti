import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/send_email_code.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late RegExp emailRegex;
  String emailRegexPool = '';
  bool sendEmailButtonEnabled = false;

  @override
  void initState() {
    buildEmailRegexPattern();
    super.initState();
  }

  void sendCode() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SendEmailCode(
        future: singletonProvider.usuariosController
            .recuperarPass('3337798743', emailController.text),
        correo: emailController.text,
        callback: () {
          Navigator.of(context).pop();
          print('Correo enviado');
        },
      ),
    );
  }

  void buildEmailRegexPattern() {
    String patterns = VariablesGlobales.emailAddressPool.join('|');
    emailRegexPool = '@(?:$patterns)\$';
    emailRegex = RegExp(emailRegexPool);
    setState(() {});
  }

  void validateEmail(String data) {
    sendEmailButtonEnabled = false;
    if (_form.currentState!.validate()) {
      sendEmailButtonEnabled = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double remainingHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  SchedulerBinding.instance
                      .addPostFrameCallback((_) => currentFocus.unfocus());
                }
              },
              child: SizedBox(
                height: remainingHeight,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: AppBanner(
                        displayText: 'Recuperar contraseña',
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Form(
                        key: _form,
                        child: LayoutBuilder(
                          builder: (context, constraints) => Column(
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.6,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                child: Lottie.asset(
                                  'assets/lotties/forgot_password.json',
                                  animate: true,
                                  repeat: false,
                                  frameRate: FrameRate(60),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: constraints.maxWidth,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Si tu correo electrónico coincide con alguno en nuestro registro, se te enviará un código para poder recuperar tu contraseña.',
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: 'Nutmeg',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: null,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    TextInput(
                                      controller: emailController,
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      hintText: 'Correo:',
                                      icon: Icons.email_outlined,
                                      focusNode: emailFocusNode,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !EmailValidator.validate(value)) {
                                          return "Ingresa un correo electrónico válido";
                                        }
                                        if (!emailRegex.hasMatch(value)) {
                                          return 'Sólo se permite el dominio ceti.mx';
                                        }
                                        return null;
                                      },
                                      onChanged: (data) => validateEmail(data!),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Expanded(
                                          flex: 1,
                                          child: SizedBox.shrink(),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: null,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    VariablesGlobales
                                                        .coloresApp[1],
                                              ),
                                              onPressed: sendEmailButtonEnabled
                                                  ? sendCode
                                                  : null,
                                              child: const Text(
                                                'Enviar',
                                                style: TextStyle(
                                                  fontFamily: 'Nutmeg',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
