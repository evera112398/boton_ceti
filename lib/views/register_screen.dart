import 'dart:ui';

import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/expansion_tile_builder.dart';
import 'package:boton_ceti/models/password_conditions.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:boton_ceti/models/timer.dart';
import 'package:boton_ceti/views/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controllerCopy;
  late Animation<double> agrandar;
  late Animation<double> _agrandarCopy;

  List<GlobalKey<FormState>> registerFormKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

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
  List<FocusNode> personalDataFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  final FocusNode emailFocusNode = FocusNode();

  final FocusNode cellphoneFocusNode = FocusNode();

  List<FocusNode> passwordFocusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  bool _is8Characters = false;
  bool _hasMayus = false;
  bool _hasMinus = false;
  bool _hasSpecial = false;
  bool _hasNumber = false;
  bool _passwordsMatch = false;
  bool _emailValidateButtonEnabled = false;
  bool _cellphoneValidateButtonEnabled = false;
  bool showFirstPasswordRequirement = false;
  bool showSecondPasswordRequirement = false;
  List<bool> expansionTileStatus = [
    false,
    false,
    false,
    false,
  ];

  String emailRegexPool = '';
  late RegExp emailRegex;

  void buildEmailRegexPattern() {
    String patterns = VariablesGlobales.emailAddressPool.join('|');
    emailRegexPool = '@(?:$patterns)\$';
    emailRegex = RegExp(emailRegexPool);
    setState(() {});
  }

  void validatePersonalData(String data) {
    expansionTileStatus[0] = false;
    if (registerFormKeys[0].currentState!.validate()) {
      expansionTileStatus[0] = true;
    }
    setState(() {});
  }

  void validateEmail(String data) {
    expansionTileStatus[1] = false;
    _emailValidateButtonEnabled = false;
    if (registerFormKeys[1].currentState!.validate()) {
      _emailValidateButtonEnabled = true;
    }
    setState(() {});
  }

  void validateCellphone(String data) {
    expansionTileStatus[2] = false;
    _cellphoneValidateButtonEnabled = false;
    if (registerFormKeys[2].currentState!.validate()) {
      _cellphoneValidateButtonEnabled = true;
    }
    setState(() {});
  }

  void _checkPassword(String password) {
    expansionTileStatus[3] = false;
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
    if (registerFormKeys[3].currentState!.validate()) {
      expansionTileStatus[3] = true;
      setState(() {});
    }
  }

  void _checkSecondPassword(String password) {
    expansionTileStatus[3] = false;
    _passwordsMatch = false;
    if (passwordController[1].text.isNotEmpty) {
      if (passwordController[1].value == passwordController[0].value) {
        _passwordsMatch = true;
      }
    }
    setState(() {});
    if (registerFormKeys[3].currentState!.validate()) {
      expansionTileStatus[3] = true;
      setState(() {});
    }
  }

  void registerNewUser() {
    bool allValid = true;
    for (var key in registerFormKeys) {
      if (!key.currentState!.validate()) {
        allValid = false;
      }
    }
    if (allValid) {
      succesfulRegister(context);
    }
  }

  Future<dynamic> succesfulRegister(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
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
                                        '¡Registrado con éxito!',
                                        style: TextStyle(
                                          fontFamily: 'Nutmeg',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.33,
                                    width: constraints.maxWidth * 0.75,
                                    child: const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'A continuación, serás redirigido al login.',
                                        style: TextStyle(
                                          fontFamily: 'Nutmeg',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.34,
                                    width: constraints.maxWidth * 0.75,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: RedirectTimer(
                                        seconds: 5,
                                        callback: () {
                                          Future.microtask(
                                            () => Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              crearRutaNamed(const Logincreen(),
                                                  'loginScreen'),
                                              (route) => false,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
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
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    buildEmailRegexPattern();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        if (_controller.status == AnimationStatus.dismissed) {
          showFirstPasswordRequirement = false;
          setState(() {});
        }
      });
    agrandar = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
    _controllerCopy = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        if (_controllerCopy.status == AnimationStatus.dismissed) {
          showSecondPasswordRequirement = false;
          setState(() {});
        }
      });
    _agrandarCopy = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controllerCopy, curve: Curves.elasticInOut),
    );
    passwordFocusNodes[0].addListener(() {
      if (!passwordFocusNodes[0].hasFocus &&
          _controller.status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    passwordFocusNodes[1].addListener(() {
      if (!passwordFocusNodes[1].hasFocus &&
          _controllerCopy.status == AnimationStatus.completed) {
        _controllerCopy.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerCopy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => currentFocus.unfocus());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
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
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Form(
                            key: registerFormKeys[0],
                            child: ExpansionTileBuilder(
                              iconStatus: expansionTileStatus[0],
                              //!ExpansionTile para Datos Personales.
                              expansionTitle: 'Datos personales',
                              initiallyExpanded: true,
                              controller: expansionTileControllers[0],
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextInput(
                                    focusNode: personalDataFocusNodes[0],
                                    controller: personalDataControllers[0],
                                    autofillHints: const [AutofillHints.name],
                                    hintText: 'Nombre:',
                                    icon: Icons.person_outline_outlined,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !VariablesGlobales
                                              .expresionesRegulares[0]
                                              .hasMatch(value)) {
                                        expansionTileControllers[0].expand();
                                        return "Ingresa un nombre válido";
                                      }
                                      return null;
                                    },
                                    onChanged: (data) =>
                                        validatePersonalData(data!),
                                    onTap: () {
                                      personalDataFocusNodes[0].requestFocus();

                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextInput(
                                    focusNode: personalDataFocusNodes[1],
                                    controller: personalDataControllers[1],
                                    autofillHints: const [
                                      AutofillHints.familyName
                                    ],
                                    hintText: 'Apellido paterno:',
                                    icon: Icons.person_outline_outlined,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !VariablesGlobales
                                              .expresionesRegulares[0]
                                              .hasMatch(value)) {
                                        expansionTileControllers[0].expand();
                                        return "Ingresa un apellido válido";
                                      }
                                      return null;
                                    },
                                    onChanged: (data) =>
                                        validatePersonalData(data!),
                                    onTap: () {
                                      personalDataFocusNodes[1].requestFocus();

                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextInput(
                                    focusNode: personalDataFocusNodes[2],
                                    controller: personalDataControllers[2],
                                    autofillHints: const [
                                      AutofillHints.familyName
                                    ],
                                    hintText: 'Apellido materno:',
                                    icon: Icons.person_outline_outlined,
                                    validator: (value) {
                                      if (value!.isNotEmpty &&
                                          !VariablesGlobales
                                              .expresionesRegulares[0]
                                              .hasMatch(value)) {
                                        expansionTileControllers[0].expand();
                                        return "Ingresa un apellido válido";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      personalDataFocusNodes[2].requestFocus();

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5)
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: registerFormKeys[1],
                            child: ExpansionTileBuilder(
                              iconStatus: expansionTileStatus[1],
                              //!ExpansionTile para correo electrónico.
                              expansionTitle: 'Correo electrónico',
                              initiallyExpanded: false,
                              controller: expansionTileControllers[1],
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextInput(
                                    focusNode: emailFocusNode,
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
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Sólo se permiten los dominios ceti.mx y live.ceti.mx';
                                      }
                                      return null;
                                    },
                                    onChanged: (data) => validateEmail(data!),
                                    onTap: () {
                                      emailFocusNode.requestFocus();

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _emailValidateButtonEnabled
                                            ? () {
                                                expansionTileStatus[1] = true;
                                                setState(() {});
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          backgroundColor:
                                              VariablesGlobales.coloresApp[1],
                                        ),
                                        child: const Text('Validar'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5)
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: registerFormKeys[2],
                            child: ExpansionTileBuilder(
                              iconStatus: expansionTileStatus[2],
                              //!ExpansionTile para celular.
                              expansionTitle: 'Número de celular',
                              initiallyExpanded: false,
                              controller: expansionTileControllers[2],
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextInput(
                                    maxCharacters: 10,
                                    focusNode: cellphoneFocusNode,
                                    keyboardType: TextInputType.phone,
                                    controller: phoneController,
                                    autofillHints: const [
                                      AutofillHints.telephoneNumber
                                    ],
                                    hintText: 'Celular:',
                                    icon: Icons.phone,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !VariablesGlobales
                                              .expresionesRegulares[1]
                                              .hasMatch(value)) {
                                        expansionTileControllers[2].expand();
                                        return "Ingresa un número de teléfono válido";
                                      }
                                      return null;
                                    },
                                    onChanged: (data) =>
                                        validateCellphone(data!),
                                    onTap: () {
                                      cellphoneFocusNode.requestFocus();

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: ElevatedButton(
                                        onPressed:
                                            _cellphoneValidateButtonEnabled
                                                ? () {
                                                    expansionTileStatus[2] =
                                                        true;
                                                    setState(() {});
                                                  }
                                                : null,
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          backgroundColor:
                                              VariablesGlobales.coloresApp[1],
                                        ),
                                        child: const Text('Validar'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5)
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          Form(
                            key: registerFormKeys[3],
                            child: ExpansionTileBuilder(
                              iconStatus: expansionTileStatus[3],
                              //!ExpansionTile para contraseña.
                              expansionTitle: 'Contraseña',
                              initiallyExpanded: false,
                              controller: expansionTileControllers[3],
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextInput(
                                    focusNode: passwordFocusNodes[0],
                                    isPassword: true,
                                    controller: passwordController[0],
                                    autofillHints: const [AutofillHints.name],
                                    hintText: 'Contraseña:',
                                    icon: Icons.password,
                                    validator: (value) {
                                      if (!_is8Characters) {
                                        expansionTileControllers[3].expand();
                                        return "Mínimo 8 caracteres.";
                                      }
                                      if (!_hasMayus) {
                                        expansionTileControllers[3].expand();
                                        return "Mínimo una mayúscula";
                                      }
                                      if (!_hasMinus) {
                                        expansionTileControllers[3].expand();
                                        return "Mínimo una minúscula";
                                      }
                                      if (!_hasSpecial) {
                                        expansionTileControllers[3].expand();
                                        return "Mínimo un caracter especial";
                                      }
                                      if (!_hasNumber) {
                                        expansionTileControllers[3].expand();
                                        return "Mínimo un número";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        _checkPassword(value!),
                                    onTap: () {
                                      showFirstPasswordRequirement = true;
                                      passwordFocusNodes[0].requestFocus();
                                      _controller.forward();
                                      setState(() {});
                                    },
                                  ),
                                ),
                                AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 300),
                                  height:
                                      showFirstPasswordRequirement ? null : 0,
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
                                          horizontal: 10, vertical: 10),
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextInput(
                                    focusNode: passwordFocusNodes[1],
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
                                        expansionTileControllers[3].expand();
                                        return "Las contraseñas no coinciden.";
                                      }
                                    },
                                    onChanged: (value) =>
                                        _checkSecondPassword(value!),
                                    onTap: () {
                                      showSecondPasswordRequirement = true;
                                      passwordFocusNodes[1].requestFocus();
                                      _controllerCopy.forward();
                                      setState(() {});
                                    },
                                  ),
                                ),
                                AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 300),
                                  height:
                                      showSecondPasswordRequirement ? null : 0,
                                  child: AnimatedBuilder(
                                    animation: _controllerCopy,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _agrandarCopy.value,
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
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.04,
                            maxHeight: 50,
                          ),
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () => registerNewUser(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VariablesGlobales.coloresApp[1],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Registrarme',
                              style: TextStyle(
                                fontFamily: 'Nutmeg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
