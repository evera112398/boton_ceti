import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/helpers/rebuild_ui.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/dynamic_alert_dialog.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:boton_ceti/models/password_conditions.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:boton_ceti/models/timer.dart';
import 'package:boton_ceti/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  final String codigo;
  final int idUsuario;
  const ChangePasswordView({
    super.key,
    required this.codigo,
    required this.idUsuario,
  });

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView>
    with TickerProviderStateMixin {
  final List<TextEditingController> passwordController = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> passwordFocusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _is8Characters = false;
  bool _hasMayus = false;
  bool _hasMinus = false;
  bool _hasSpecial = false;
  bool _hasNumber = false;
  bool _passwordsMatch = false;
  bool showFirstPasswordRequirement = false;
  bool showSecondPasswordRequirement = false;
  bool sendButtonEnabled = false;
  bool hasError = false;

  late AnimationController _controller;
  late AnimationController _controllerCopy;
  late Animation<double> agrandar;
  late Animation<double> _agrandarCopy;

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
      if (passwordFocusNodes[1].hasFocus) {
        showSecondPasswordRequirement = true;
        _controllerCopy.forward();
        setState(() {});
      }
    });
  }

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
    sendButtonEnabled = false;
    if (allFieldsValid()) {
      sendButtonEnabled = true;
    }
    setState(() {});
  }

  void _checkSecondPassword(String password) {
    _passwordsMatch = false;
    if (passwordController[1].text.isNotEmpty) {
      if (passwordController[1].value == passwordController[0].value) {
        _passwordsMatch = true;
      }
    }
    sendButtonEnabled = false;
    if (allFieldsValid()) {
      sendButtonEnabled = true;
    }
    setState(() {});
  }

  void switchFocusNode(FocusNode oldFocusNode, FocusNode newFocusNode) {
    oldFocusNode.unfocus();
    newFocusNode.requestFocus();
  }

  bool allFieldsValid() {
    if (!_is8Characters ||
        !_hasMayus ||
        !_hasMinus ||
        !_hasSpecial ||
        !_hasNumber ||
        !_passwordsMatch) {
      return false;
    }
    return true;
  }

  Widget successContent() {
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
                      height: constraints.maxHeight * 0.25,
                      width: constraints.maxWidth * 0.75,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Contraseña cambiada con éxito',
                          style: TextStyle(
                            fontFamily: 'Nutmeg',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.25,
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
                      height: constraints.maxHeight * 0.4,
                      width: constraints.maxWidth * 0.75,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: RedirectTimer(
                          seconds: 5,
                          callback: () {
                            Future.microtask(
                              () => Navigator.of(context).pushAndRemoveUntil(
                                crearRutaNamed(
                                    const LoginScreen(), 'loginScreen'),
                                (route) => false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void changePassword() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: DynamicAlertDialog(
          actions: hasError
              ? [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VariablesGlobales.coloresApp[1],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (!hasError) {
                        SchedulerBinding.instance.addPostFrameCallback(
                          (_) {
                            Navigator.of(context).pop();
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
                ]
              : null,
          child: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 2)).then(
              (value) =>
                  singletonProvider.usuariosController.updateRecuperarPass(
                widget.codigo,
                widget.idUsuario,
                passwordController[0].text,
              ),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!snapshot.data!['ok']) {
                  hasError = true;
                  RebuildUI.rebuild(context, setState);
                  return ErrorPopupContent(error: snapshot.data!['payload']);
                }
                return successContent();
              }
              if (snapshot.hasError) {
                hasError = true;
                RebuildUI.rebuild(context, setState);
                return const ErrorPopupContent(
                    error: 'Sucedió un error inesperado.');
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: VariablesGlobales.coloresApp[1],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Validando...',
                            style: TextStyle(
                              fontFamily: 'Nutmeg',
                              fontWeight: FontWeight.w300,
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
        ),
      ),
    );
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
                        displayText: 'Ingresa nueva contraseña:',
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        width: double.infinity,
                        height: null,
                        child: Form(
                          key: _key,
                          child: LayoutBuilder(
                            builder: (context, constraints) => Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: constraints.maxHeight * 0.25,
                                  child: Lottie.asset(
                                    'assets/lotties/lock.json',
                                    animate: true,
                                    repeat: true,
                                    reverse: true,
                                    frameRate: FrameRate(60),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 3,
                                      )
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      TextInput(
                                        focusNode: passwordFocusNodes[0],
                                        isPassword: true,
                                        controller: passwordController[0],
                                        autofillHints: const [
                                          AutofillHints.name
                                        ],
                                        hintText: 'Contraseña:',
                                        icon: Icons.password,
                                        validator: (value) {
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
                                        onFieldSubmited: (value) =>
                                            switchFocusNode(
                                          passwordFocusNodes[0],
                                          passwordFocusNodes[1],
                                        ),
                                      ),
                                      AnimatedContainer(
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: showFirstPasswordRequirement
                                            ? null
                                            : 0,
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
                                              vertical: 10,
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                      const SizedBox(height: 20),
                                      TextInput(
                                        focusNode: passwordFocusNodes[1],
                                        isPassword: true,
                                        controller: passwordController[1],
                                        autofillHints: const [
                                          AutofillHints.name
                                        ],
                                        hintText: 'Repetir contraseña:',
                                        icon: Icons.password,
                                        validator: (value) {
                                          return null;
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
                                      AnimatedContainer(
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: showSecondPasswordRequirement
                                            ? null
                                            : 0,
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
                                              vertical: 10,
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                onPressed: sendButtonEnabled
                                                    ? changePassword
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
                    )
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
