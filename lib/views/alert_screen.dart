import 'dart:ui';
import 'package:boton_ceti/models/alert_card.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
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
                          bottomRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 3),
                          blurRadius: 1,
                          spreadRadius: 2,
                          color: Colors.black.withOpacity(0.6),
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
                              Color.fromRGBO(42, 166, 255, 0.65),
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
                                    'Bienvenido: Edwin Manuel Vera',
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
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                AlertCard(
                                  alertType: 'SEGURIDAD',
                                  alertIcon: Icons.copy,
                                  containerHeight: constraints.maxHeight,
                                  alertDescription:
                                      'Viví o presencié un incidente de seguridad.',
                                  imagePath: 'assets/icons/seguridad.png',
                                ),
                                const SizedBox(height: 10),
                                AlertCard(
                                  alertType: 'MÉDICO',
                                  alertIcon: Icons.copy,
                                  containerHeight: constraints.maxHeight,
                                  alertDescription:
                                      'Sufrí un accidente médico.',
                                  imagePath: 'assets/icons/medico.png',
                                ),
                                const SizedBox(height: 10),
                                AlertCard(
                                  alertType: 'ACOSO',
                                  alertIcon: Icons.copy,
                                  containerHeight: constraints.maxHeight,
                                  alertDescription:
                                      'Sufrí o presencié acoso o bullying',
                                  imagePath: 'assets/icons/acoso.jpg',
                                ),
                                const SizedBox(height: 10),
                                AlertCard(
                                  alertType: 'INCENDIO',
                                  alertIcon: Icons.copy,
                                  containerHeight: constraints.maxHeight,
                                  alertDescription:
                                      'Hay un incendio en el plantel.',
                                  imagePath: 'assets/icons/incendio.png',
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
