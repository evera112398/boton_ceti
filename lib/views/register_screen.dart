import 'dart:convert';

import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/data/establecimientos_data.dart';
import 'package:boton_ceti/data/user_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/adaptative_button.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/dynamic_alert_dialog.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:boton_ceti/models/expansion_tile_builder.dart';
import 'package:boton_ceti/models/password_conditions.dart';
import 'package:boton_ceti/models/send_email_code.dart';
import 'package:boton_ceti/models/send_sms_code.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:boton_ceti/models/timer.dart';
import 'package:boton_ceti/views/login.dart';
import 'package:boton_ceti/views/validate_email.dart';
import 'package:boton_ceti/views/validate_sms.dart';
import 'package:crypto/crypto.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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

  final ScrollController _registerScrollController = ScrollController();

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
    FocusNode()
  ];

  final List<StepState> _states = [
    StepState.editing,
    StepState.disabled,
    StepState.disabled,
    StepState.disabled,
  ];

  final List<EstablecimientosData> plantelesData = [];

  List<String> plantelItems = [];

  int? selectedEstablecimiento;
  String? selectedPlantel;

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

  String emailRegexPool = '';
  late RegExp emailRegex;
  final List<String> buttonTexts = [
    'Validar',
    'Siguiente',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() async {
        if (_controller.status == AnimationStatus.dismissed) {
          showFirstPasswordRequirement = false;
          setState(() {});
        }
        if (_controller.status == AnimationStatus.completed) {
          _registerScrollController.animateTo(
              _registerScrollController.position.maxScrollExtent * 1.2,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut);
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
        if (_controllerCopy.status == AnimationStatus.completed) {
          _registerScrollController.animateTo(
              _registerScrollController.position.maxScrollExtent * 1.2,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut);
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
      if (passwordFocusNodes[1].hasFocus) {
        showSecondPasswordRequirement = true;
        _controllerCopy.forward();
        setState(() {});
      }
    });
    getEstablecimientos().whenComplete(() {
      buildEmailRegexPattern();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerCopy.dispose();
    super.dispose();
  }

  Future<void> getEstablecimientos() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    final response =
        await singletonProvider.usuariosController.getEstablecimientos();
    if (response['ok']) {
      for (var plantel in response['payload']) {
        plantelesData.add(
          EstablecimientosData(
            idEstablecimiento: plantel['id_establecimiento'],
            nombre: plantel['nombre'],
            latitud: double.tryParse(plantel['latitud']) ?? 0.0000,
            longitud: double.tryParse(plantel['longitud']) ?? 0.0000,
          ),
        );
        plantelItems.add(plantel['nombre']);
      }
    }
    setState(() {});
  }

  void buildEmailRegexPattern() {
    String patterns = VariablesGlobales.emailAddressPool.join('|');
    emailRegexPool = '@(?:$patterns)\$';
    emailRegex = RegExp(emailRegexPool);
    setState(() {});
  }

  void validatePersonalData(String data) {
    _states[0] = StepState.error;
    if (registerFormKeys[0].currentState!.validate()) {
      _states[0] = StepState.complete;
    }
    setState(() {});
  }

  void validateEmail(String data) {
    _states[1] = StepState.error;
    _emailValidateButtonEnabled = false;
    if (registerFormKeys[1].currentState!.validate()) {
      _emailValidateButtonEnabled = true;
    }
    setState(() {});
  }

  void validateCellphone(String data) {
    _states[2] = StepState.error;
    _cellphoneValidateButtonEnabled = false;
    if (registerFormKeys[2].currentState!.validate()) {
      _cellphoneValidateButtonEnabled = true;
    }
    setState(() {});
  }

  void _checkPassword(String password) {
    _states[3] = StepState.error;
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
      _states[3] = StepState.complete;
      setState(() {});
    }
  }

  void _checkSecondPassword(String password) {
    _states[3] = StepState.error;
    _passwordsMatch = false;
    if (passwordController[1].text.isNotEmpty) {
      if (passwordController[1].value == passwordController[0].value) {
        _passwordsMatch = true;
      }
    }
    setState(() {});
    if (registerFormKeys[3].currentState!.validate()) {
      _states[3] = StepState.complete;
      setState(() {});
    }
  }

  void registerNewUser() async {
    bool allValid = true;
    for (var key in registerFormKeys) {
      if (!key.currentState!.validate()) {
        allValid = false;
      }
    }
    if (allValid) {
      final passToHash = utf8.encode(passwordController[0].text);
      final hashedPassword = sha512.convert(passToHash);
      final singletonProvider =
          Provider.of<ControllersProvider>(context, listen: false);
      UserData newUser = UserData(
        nombre: personalDataControllers[0].text,
        apellidoPaterno: personalDataControllers[1].text,
        apellidoMaterno: personalDataControllers[2].text,
        correo: emailController.text,
        celular: phoneController.text,
        idEstablecimiento: selectedEstablecimiento!,
        password: hashedPassword.toString(),
        acepto: 1,
      );
      final response =
          await singletonProvider.usuariosController.createUsuario(newUser);
      if (response['ok']) {
        Future.microtask(() => succesfulRegister(context));
      } else {
        Future.microtask(
          () => showDialog(
            context: context,
            builder: (context) {
              return DynamicAlertDialog(
                child: ErrorPopupContent(
                  error: response['payload'],
                ),
              );
            },
          ),
        );
      }
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
                                              crearRutaNamed(
                                                  const LoginScreen(),
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

  //!Esta función es la que evalúa que texto debe tener el botón mostrado en cada una de las cards del registro.
  String setAdaptativeButtonText(int step) {
    if (_states[step] == StepState.complete) {
      return buttonTexts[1];
    }
    return buttonTexts[0];
  }

//!Esta función se encarga de darle la funcionabilidad al botón.
  void setAdaptativeButtonFunction(int step) async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    bool emailValidated = false;
    bool smsValidated = false;
    if (step == 1 &&
        (_states[step] == StepState.editing ||
            _states[step] == StepState.error)) {
      if (!await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SendEmailCode(
          future: singletonProvider.usuariosController
              .sendCodigoValidacionCorreo(emailController.text),
          correo: emailController.text,
          callback: () {
            Navigator.of(context).pop(true);
          },
        ),
      )) {
        return;
      }
      Future.microtask(() async {
        emailValidated = await Navigator.of(context).push(crearRutaNamed(
            ValidateEmail(correo: emailController.text), 'validateEmail'));
        if (emailValidated) {
          _states[step] = StepState.complete;
        } else {
          _states[step] = StepState.error;
        }
        setState(() {});
      });
      return;
    }

    if (step == 2 &&
        (_states[step] == StepState.editing ||
            _states[step] == StepState.error)) {
      if (!mounted) return;
      if (!await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SendSMSCode(celular: phoneController.text),
      )) {
        return;
      }
      Future.microtask(() async {
        smsValidated = await Navigator.of(context).push(crearRutaNamed(
            ValidateSMS(cellphone: phoneController.text), 'validateSMS'));
        if (smsValidated) {
          _states[step] = StepState.complete;
        } else {
          _states[step] = StepState.error;
        }
        setState(() {});
      });
      return;
    }
    int currentExpansionTile = step;
    int nextExpansionTile = step + 1;
    expansionTileControllers[currentExpansionTile].collapse();
    if (step < 3) {
      expansionTileControllers[nextExpansionTile].expand();
      _states[nextExpansionTile] = StepState.editing;
    }
    setState(() {});
  }

  void switchFocusNode(FocusNode oldFocusNode, FocusNode newFocusNode) {
    oldFocusNode.unfocus();
    newFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    double remainingHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: VariablesGlobales.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                    child: SingleChildScrollView(
                      controller: _registerScrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Form(
                            key: registerFormKeys[0],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              //!ExpansionTile para Datos Personales.
                              child: ExpansionTileBuilder(
                                isExpandable: _states[0] != StepState.disabled
                                    ? true
                                    : false,
                                iconStatus: _states[0],
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
                                        personalDataFocusNodes[0]
                                            .requestFocus();
                                        setState(() {});
                                      },
                                      onFieldSubmited: (value) =>
                                          switchFocusNode(
                                        personalDataFocusNodes[0],
                                        personalDataFocusNodes[1],
                                      ),
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
                                        personalDataFocusNodes[1]
                                            .requestFocus();
                                        setState(() {});
                                      },
                                      onFieldSubmited: (value) =>
                                          switchFocusNode(
                                        personalDataFocusNodes[1],
                                        personalDataFocusNodes[2],
                                      ),
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
                                        personalDataFocusNodes[2]
                                            .requestFocus();
                                        setState(() {});
                                      },
                                      onFieldSubmited: (value) {
                                        switchFocusNode(
                                          personalDataFocusNodes[2],
                                          personalDataFocusNodes[3],
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: VariablesGlobales
                                                      .coloresApp[1],
                                                ),
                                      ),
                                      child: DropdownButtonFormField2(
                                        focusNode: personalDataFocusNodes[3],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        isDense: true,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .symmetric(
                                            vertical: 20,
                                            horizontal: 0,
                                          ),
                                          prefixIcon: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.school,
                                              ),
                                            ],
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        hint: LayoutBuilder(
                                          builder: (context, constraints) =>
                                              Text(
                                            'Plantel:',
                                            style: TextStyle(
                                              fontSize:
                                                  constraints.maxHeight * 0.7,
                                            ),
                                          ),
                                        ),
                                        value: selectedPlantel,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPlantel = value!;
                                            selectedEstablecimiento =
                                                plantelesData
                                                    .firstWhere((element) =>
                                                        element.nombre ==
                                                        selectedPlantel)
                                                    .idEstablecimiento;
                                          });
                                          validatePersonalData(value!);
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Selecciona un plantel.';
                                          }
                                          return null;
                                        },
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.zero,
                                        ),
                                        style: const TextStyle(
                                          fontFamily: 'Nutmeg',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                        items: plantelItems.map((plantel) {
                                          return DropdownMenuItem(
                                            value: plantel,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 10),
                                              child: Text(
                                                plantel,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
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
                                        child: AdaptativeButton(
                                          buttonText:
                                              setAdaptativeButtonText(0),
                                          onPressed: _states[0] ==
                                                  StepState.complete
                                              ? () =>
                                                  setAdaptativeButtonFunction(0)
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: registerFormKeys[1],
                            //!ExpansionTile para correo electrónico.
                            child: ExpansionTileBuilder(
                              isExpandable: _states[1] != StepState.disabled
                                  ? true
                                  : false,
                              iconStatus: _states[1],
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
                                        return 'Sólo se permite el dominio ceti.mx';
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
                                      child: AdaptativeButton(
                                        buttonText: setAdaptativeButtonText(1),
                                        onPressed: _emailValidateButtonEnabled
                                            ? () =>
                                                setAdaptativeButtonFunction(1)
                                            : null,
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
                            //!ExpansionTile para celular.
                            child: ExpansionTileBuilder(
                              isExpandable: _states[2] != StepState.disabled
                                  ? true
                                  : false,
                              iconStatus: _states[2],
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
                                      child: AdaptativeButton(
                                        buttonText: setAdaptativeButtonText(2),
                                        onPressed:
                                            _cellphoneValidateButtonEnabled
                                                ? () =>
                                                    setAdaptativeButtonFunction(
                                                      2,
                                                    )
                                                : null,
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
                            //!ExpansionTile para contraseña.
                            child: ExpansionTileBuilder(
                              isExpandable: _states[3] != StepState.disabled
                                  ? true
                                  : false,
                              iconStatus: _states[3],
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
                                    onFieldSubmited: (value) => switchFocusNode(
                                      passwordFocusNodes[0],
                                      passwordFocusNodes[1],
                                    ),
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
                  Row(
                    children: [
                      Expanded(
                        child: IntrinsicHeight(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: ElevatedButton(
                              onPressed: () => registerNewUser(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    VariablesGlobales.coloresApp[1],
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
