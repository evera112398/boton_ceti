import 'dart:ui';
import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/views/home_screen.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int passLength = 0;
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: VariablesGlobales.bgColor,
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
                                      'SecurePush',
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
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: constraints.maxWidth * 0.8,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Bienvenido',
                                    style: TextStyle(
                                      fontFamily: 'Nutmeg',
                                      color: VariablesGlobales.coloresApp[1],
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.05),
                            height: constraints.maxHeight * 0.135,
                            width: constraints.maxWidth * 0.9,
                            child: TextFormField(
                              cursorColor: VariablesGlobales.coloresApp[0],
                              controller: controllerPhone,
                              autofillHints: const [AutofillHints.username],
                              onTap: () {
                                isIconVisible = false;
                                passwordIsHidden = true;
                                setState(() {});
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.account_box_outlined),
                                  labelText: 'Usuario'),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.09),
                            height: constraints.maxHeight * 0.135,
                            width: constraints.maxWidth * 0.9,
                            child: TextFormField(
                                cursorColor: VariablesGlobales.coloresApp[0],
                                controller: controllerPassword,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                onEditingComplete: () =>
                                    TextInput.finishAutofillContext(),
                                obscureText: passwordIsHidden,
                                decoration: InputDecoration(
                                    icon: const Icon(Icons.password),
                                    labelText: 'Contraseña',
                                    suffixIcon: isIconVisible
                                        ? IconButton(
                                            onPressed: () {
                                              passwordIsHidden =
                                                  !passwordIsHidden;
                                              setState(() {});
                                            },
                                            icon: Icon(passwordIsHidden
                                                ? Icons.visibility_off
                                                : Icons.visibility))
                                        : null),
                                onChanged: (value) {
                                  value.length > 1
                                      ? isIconVisible = true
                                      : isIconVisible = false;
                                  passLength = value.length;
                                  setState(() {});
                                },
                                onTap: () {
                                  passLength > 1 ? isIconVisible = true : null;
                                  setState(() {});
                                }),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 40),
                            height: constraints.maxHeight * 0.1,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: VariablesGlobales.coloresApp[1],
                              borderRadius: BorderRadius.circular(
                                  20.0), // Radio de los bordes del container
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Colors.transparent;
                                  },
                                ),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              child: const Text(
                                "Ingresar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 26),
                              ),
                              onPressed: () => Future.microtask(() {
                                Navigator.of(context).push(
                                  crearRutaNamed(
                                      const HomeScreen(), 'homeScreen'),
                                );
                              }),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.05),
                            height: constraints.maxHeight * 0.135,
                            width: constraints.maxWidth * 0.9,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Olvidé mi contraseña',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Registrarme',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              VariablesGlobales.coloresApp[1],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            /* Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            height: constraints.maxHeight * 0.5,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: VariablesGlobales.coloresApp[1],
                              borderRadius: BorderRadius.circular(
                                  20.0), // Radio de los bordes del container
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Colors.transparent;
                                  },
                                ),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              child: const Text(
                                "Ingresar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 26),
                              ),
                              onPressed: () => Future.microtask(() {
                                Navigator.of(context).push(
                                  crearRutaNamed(
                                      const HomeScreen(), 'homeScreen'),
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ))) */
          ],
        ),
      ),
    );
  }
}
