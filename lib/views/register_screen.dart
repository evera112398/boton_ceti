import 'dart:ui';

import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/expansion_tile_builder.dart';
import 'package:boton_ceti/models/password_conditions.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller_copy;
  late Animation<double> agrandar;
  late Animation<double> agrandar_copy;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  List<ExpansionTileController> expansionTileControllers = [
    ExpansionTileController(),
    ExpansionTileController(),
    ExpansionTileController(),
    ExpansionTileController(),
    ExpansionTileController(),
  ];
  List<TextEditingController> personalDataControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  TextEditingController emailController =
      TextEditingController(); //? Controlador para el correo electrónico.

  TextEditingController phoneController =
      TextEditingController(); //? Controlador para el correo electrónico.

  List<TextEditingController> passwordController = [
    //? Controlador para las contraseñas.
    TextEditingController(),
    TextEditingController()
  ];
  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  bool _is8Characters = false;
  bool _hasMayus = false;
  bool _hasMinus = false;
  bool _hasSpecial = false;
  bool _hasNumber = false;
  bool _passwordsMatch = false;

  void _checkPassword(String password) {
    _hasNumber = false;
    _is8Characters = false;
    _hasMayus = false;
    _hasMinus = false;
    _hasSpecial = false;
    _passwordsMatch = false;

    if (VariablesGlobales.expresionesRegulares[2].hasMatch(password)) {
      _hasNumber = true;
    }
    if (VariablesGlobales.expresionesRegulares[3].hasMatch(password)) {
      _hasMayus = true;
    }
    if (VariablesGlobales.expresionesRegulares[4].hasMatch(password)) {
      _hasMinus = true;
    }
    if (VariablesGlobales.expresionesRegulares[5].hasMatch(password)) {
      _hasSpecial = true;
    }
    if (passwordController[0].text.length >= 8) {
      _is8Characters = true;
    }
    if (passwordController[1].text.isNotEmpty) {
      if (passwordController[1].value == passwordController[0].value) {
        _passwordsMatch = true;
      }
    }
    setState(() {});
    if (_passwordKey.currentState!.validate()) {}
  }

  void _checkSecondPassword(String password) {
    _passwordsMatch = false;
    if (passwordController[1].text.isNotEmpty) {
      if (passwordController[1].value == passwordController[0].value) {
        _passwordsMatch = true;
      }
    }
    setState(() {});
    if (_passwordKey.currentState!.validate()) {}
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    agrandar = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
    _controller_copy = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    agrandar_copy = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller_copy, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller_copy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      height: null,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 3),
                            blurRadius: 1,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.4),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: Image.asset(
                          'assets/images/plantel_colomos.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1.1, sigmaY: 1.1),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 104, 178, 0.85),
                                Color.fromRGBO(0, 104, 178, 0.85),
                                Color.fromRGBO(58, 1, 102, 0.65)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double squareSize = constraints.maxWidth * 0.15;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: squareSize,
                              width: squareSize,
                              child: Image.asset(
                                'assets/images/ceti blanco.png',
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * 0.8,
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Registro de alumnos',
                                      style: TextStyle(
                                        fontFamily: 'Nutmeg',
                                        color: Colors.white,
                                        fontSize: 24,
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
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ExpansionTileBuilder(
                          //!ExpansionTile para Datos Personales.
                          expansionTitle: 'Datos personales',
                          initiallyExpanded: true,
                          controller: expansionTileControllers[0],
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextInput(
                                controller: personalDataControllers[0],
                                autofillHints: const [AutofillHints.name],
                                hintText: 'Nombre:',
                                icon: Icons.person_outline_outlined,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !VariablesGlobales.expresionesRegulares[0]
                                          .hasMatch(value)) {
                                    expansionTileControllers[0].expand();
                                    return "Ingresa un nombre válido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextInput(
                                controller: personalDataControllers[1],
                                autofillHints: const [AutofillHints.familyName],
                                hintText: 'Apellido paterno:',
                                icon: Icons.person_outline_outlined,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !VariablesGlobales.expresionesRegulares[0]
                                          .hasMatch(value)) {
                                    expansionTileControllers[0].expand();
                                    return "Ingresa un apellido válido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextInput(
                                controller: personalDataControllers[2],
                                autofillHints: const [AutofillHints.familyName],
                                hintText: 'Apellido materno:',
                                icon: Icons.person_outline_outlined,
                                validator: (value) {
                                  if (value!.isNotEmpty &&
                                      !VariablesGlobales.expresionesRegulares[0]
                                          .hasMatch(value)) {
                                    expansionTileControllers[0].expand();
                                    return "Ingresa un apellido válido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                        const SizedBox(height: 20),
                        ExpansionTileBuilder(
                          //!ExpansionTile para correo electrónico.

                          expansionTitle: 'Correo electrónico',
                          initiallyExpanded: false,
                          controller: expansionTileControllers[1],
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextInput(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                autofillHints: const [AutofillHints.email],
                                hintText: 'Correo electrónico:',
                                icon: Icons.email_outlined,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !EmailValidator.validate(value)) {
                                    expansionTileControllers[1].expand();
                                    return "Ingresa un correo electrónico válido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                        const SizedBox(height: 20),
                        ExpansionTileBuilder(
                          //!ExpansionTile para celular.
                          expansionTitle: 'Número de celular',
                          initiallyExpanded: false,
                          controller: expansionTileControllers[2],
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextInput(
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                autofillHints: const [
                                  AutofillHints.telephoneNumber
                                ],
                                hintText: 'Celular:',
                                icon: Icons.phone,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !VariablesGlobales.expresionesRegulares[1]
                                          .hasMatch(value)) {
                                    expansionTileControllers[2].expand();
                                    return "Ingresa un número de teléfono válido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                        const SizedBox(height: 20),

                        Form(
                          key: _passwordKey,
                          child: ExpansionTileBuilder(
                            //!ExpansionTile para contraseña.
                            expansionTitle: 'Contraseña',
                            initiallyExpanded: false,
                            controller: expansionTileControllers[3],
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextInput(
                                  isPassword: true,
                                  controller: passwordController[0],
                                  autofillHints: const [AutofillHints.name],
                                  hintText: 'Contraseña:',
                                  icon: Icons.password,
                                  validator: (value) {
                                    if (!_is8Characters) {
                                      return "Mínimo 8 caracteres.";
                                    }
                                    if (!_hasMayus) {
                                      return "Mínimo una mayúscula";
                                    }
                                    if (!_hasMinus) {
                                      return "Mínimo una minúscula";
                                    }
                                    if (!_hasSpecial) {
                                      return "Mínimo un caracter especial";
                                    }
                                    if (!_hasNumber) {
                                      return "Mínimo un número";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _checkPassword(value!),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: agrandar.value,
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black38, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: double.infinity,
                                    height: null,
                                    child: PasswordConditionChecker(
                                      settedConditions: {
                                        'Contiene al menos 8 caracteres.':
                                            _is8Characters,
                                        'Contiene al menos un número.':
                                            _hasNumber,
                                        'Contiene al menos una mayúscula.':
                                            _hasMayus,
                                        'Contiene al menos una minúscula.':
                                            _hasMinus,
                                        'Contiene al menos un carácter especial.':
                                            _hasSpecial,
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextInput(
                                  isPassword: true,
                                  controller: passwordController[1],
                                  autofillHints: const [AutofillHints.name],
                                  hintText: 'Repetir contraseña:',
                                  icon: Icons.password,
                                  validator: (value) {
                                    if (passwordController[1].value ==
                                        passwordController[0].value) {
                                      return null;
                                    } else {
                                      return "Las contraseñas no coinciden.";
                                    }
                                  },
                                  onChanged: (value) =>
                                      _checkSecondPassword(value!),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: AnimatedBuilder(
                                  animation: _controller_copy,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: agrandar_copy.value,
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black38, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: double.infinity,
                                    height: null,
                                    child: PasswordConditionChecker(
                                      settedConditions: {
                                        'Las contraseñas coinciden':
                                            _passwordsMatch
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // const SizedBox(height: 20),
                        // ExpansionTileBuilder(
                        //   //!ExpansionTile para documentos legales.
                        //   expansionTitle: 'Documentos legales',
                        //   initiallyExpanded: false,
                        //   controller: expansionTileControllers[4],
                        //   children: [
                        //     Container(
                        //       margin: const EdgeInsets.symmetric(vertical: 5),
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 10),
                        //       child: TextInput(
                        //         controller: personalDataControllers[0],
                        //         autofillHints: const [AutofillHints.name],
                        //         hintText: 'Nombre:',
                        //         icon: Icons.person_outline_outlined,
                        //         validator: (value) {
                        //           if (value!.isEmpty ||
                        //               !VariablesGlobales.expresionesRegulares[0]
                        //                   .hasMatch(value)) {
                        //             expansionTileControllers[4].expand();
                        //             return "Ingresa un nombre válido";
                        //           }
                        //           return null;
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Registrarme'),
              onPressed: () {
                if (formKey.currentState!.validate()) {}
              },
            )
          ],
        ),
      ),
    );
  }
}
