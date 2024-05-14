import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/controllers/encryption_controller.dart';
import 'package:boton_ceti/controllers/login_controller.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:boton_ceti/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Logincreen extends StatefulWidget {
  const Logincreen({super.key});

  @override
  State<Logincreen> createState() => _LogincreenState();
}

class _LogincreenState extends State<Logincreen> {
  bool isIconVisible = false;
  bool passwordIsHidden = true;
  bool showActivateAccount = false;
  final controllerPhone = TextEditingController();
  final controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> loginControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  final List<FocusNode> loginFocusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  int passLength = 0;

  Future<void> doLogin() async {
    // if (_formKey.currentState!.validate()) {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    final response = await singletonProvider.loginController.login(
      loginControllers[0].text,
      loginControllers[1].text,
    );
    print(response);
    // }
  }

  @override
  Widget build(BuildContext context) {
    double remainingHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: VariablesGlobales.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => currentFocus.unfocus());
              }
            },
            child: SizedBox(
              height: remainingHeight,
              width: double.infinity,
              child: Column(
                children: [
                  const Expanded(
                    flex: 1,
                    child: AppBanner(),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, constraints) => Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              width: constraints.maxWidth * 0.95,
                              height: constraints.maxHeight * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: VariablesGlobales.bgColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) => Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: constraints.maxWidth * 0.7,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                'Inicio de sesión',
                                                style: TextStyle(
                                                  fontFamily: 'Nutmeg',
                                                  color: VariablesGlobales
                                                      .coloresApp[2],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextInput(
                                                controller: loginControllers[0],
                                                autofillHints: const [
                                                  AutofillHints.username
                                                ],
                                                hintText: 'Usuario',
                                                icon: Icons.person,
                                                focusNode: loginFocusNodes[0],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Completa este campo.';
                                                  }
                                                  return null;
                                                },
                                                onTap: () {
                                                  loginFocusNodes[0]
                                                      .requestFocus();
                                                },
                                                onFieldSubmited: (value) {
                                                  loginFocusNodes[0]
                                                      .requestFocus();
                                                  loginFocusNodes[1]
                                                      .requestFocus();
                                                },
                                              ),
                                              SizedBox(
                                                height:
                                                    constraints.maxHeight * 0.1,
                                              ),
                                              TextInput(
                                                controller: loginControllers[1],
                                                autofillHints: const [
                                                  AutofillHints.password
                                                ],
                                                hintText: 'Contraseña',
                                                isPassword: true,
                                                icon: Icons.password,
                                                focusNode: loginFocusNodes[1],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Completa este campo.';
                                                  }
                                                  return null;
                                                },
                                                onTap: () {
                                                  loginFocusNodes[1]
                                                      .requestFocus();
                                                },
                                                onFieldSubmited: (value) {
                                                  loginFocusNodes[1].unfocus();
                                                  doLogin();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      VariablesGlobales
                                                          .coloresApp[1],
                                                ),
                                                onPressed: () => doLogin(),
                                                child: const Text(
                                                  'Ingresar',
                                                  style: TextStyle(
                                                    fontFamily: 'Nutmeg',
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                  10,
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) => Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: constraints.maxWidth * 0.4,
                                        child: FittedBox(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Olvidé mi contraseña.',
                                                style: TextStyle(
                                                  fontFamily: 'Nutmeg',
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: VariablesGlobales
                                                      .coloresApp[1],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        width: constraints.maxWidth * 0.75,
                                        child: FittedBox(
                                          child: Row(
                                            children: [
                                              const Text(
                                                '¿Aún no tienes una cuenta?',
                                                style: TextStyle(
                                                  fontFamily: 'Nutmeg',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              GestureDetector(
                                                onTap: () => Future.microtask(
                                                  () => Navigator.of(context)
                                                      .push(
                                                    crearRutaNamed(
                                                      const RegisterScreen(),
                                                      'registerScreen',
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Regístrate.',
                                                  style: TextStyle(
                                                    fontFamily: 'Nutmeg',
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: VariablesGlobales
                                                        .coloresApp[1],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/images/castor.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
