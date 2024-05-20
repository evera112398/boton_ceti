import 'dart:ui';

import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  final String? displayText;
  const AppBanner({super.key, this.displayText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            displayText ?? 'SecurePush',
                            style: const TextStyle(
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
    );
  }
}
