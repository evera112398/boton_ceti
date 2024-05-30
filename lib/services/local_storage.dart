import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/dynamic_alert_dialog.dart';
import 'package:boton_ceti/views/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clearStorage(BuildContext context) async {
    await Future.microtask(() => showDialog(
          context: context,
          builder: (context) {
            return DynamicAlertDialog(
              actions: [
                ElevatedButton(
                  onPressed: () => Future.microtask(
                    () async {
                      await prefs.clear();
                      Future.microtask(
                        () => Navigator.of(context).pushAndRemoveUntil(
                            crearRutaNamed(const LoginScreen(), 'loginScreen'),
                            (route) => false),
                      );
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: VariablesGlobales.coloresApp[1]),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(
                      fontFamily: 'Nutmeg',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
              child: LayoutBuilder(
                builder: (context, constraints) => Center(
                  child: SizedBox(
                    height: constraints.maxHeight * 0.9,
                    width: constraints.maxWidth * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lotties/question.json',
                          animate: true,
                          repeat: false,
                          fit: BoxFit.contain,
                          frameRate: FrameRate(60),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '¿Quieres cerrar la sesión?',
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
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  static Future<void> clearUserProfiles() async {
    userProfiles = '';
  }

  static void changeLocationStatus() {
    location = true;
  }

  static int? get idUsuario {
    if (prefs.getInt('idUsuario') != null) {
      return prefs.getInt('idUsuario');
    }
    return null;
  }

  static set idUsuario(int? val) {
    prefs.setInt('idUsuario', val!);
  }

  static int? get idPerfil {
    if (prefs.getInt('idPerfil') != null) {
      return prefs.getInt('idPerfil');
    }
    return null;
  }

  static set idPerfil(int? val) {
    prefs.setInt('idPerfil', val!);
  }

  static String? get tokenUsuario {
    if (prefs.getString('tokenUsuario') != null) {
      return prefs.getString('tokenUsuario');
    }
    return null;
  }

  static set tokenUsuario(String? val) {
    prefs.setString('tokenUsuario', val!);
  }

  static bool? get hasSession {
    if (prefs.getBool('hasSession') != null) {
      return prefs.getBool('hasSession');
    }
    return null;
  }

  static set hasSession(bool? val) {
    prefs.setBool('hasSession', val!);
  }

  static String? get userProfiles {
    if (prefs.getString('userProfiles') != null) {
      return prefs.getString('userProfiles');
    }
    return null;
  }

  static set userProfiles(String? val) {
    prefs.setString('userProfiles', val!);
  }

  static String? get nombre {
    if (prefs.getString('nombre') != null) {
      return prefs.getString('nombre');
    }
    return null;
  }

  static set nombre(String? val) {
    prefs.setString('nombre', val!);
  }

  static String? get apellidoPaterno {
    if (prefs.getString('apellido_paterno') != null) {
      return prefs.getString('apellido_paterno');
    }
    return null;
  }

  static set apellidoPaterno(String? val) {
    prefs.setString('apellido_paterno', val!);
  }

  static String? get apellidoMaterno {
    if (prefs.getString('apellido_materno') != null) {
      return prefs.getString('apellido_materno');
    }
    return null;
  }

  static set apellidoMaterno(String? val) {
    prefs.setString('apellido_materno', val!);
  }

  static String? get correo {
    if (prefs.getString('correo') != null) {
      return prefs.getString('correo');
    }
    return null;
  }

  static set correo(String? val) {
    prefs.setString('correo', val!);
  }

  static String? get celular {
    if (prefs.getString('celular') != null) {
      return prefs.getString('celular');
    }
    return null;
  }

  static set celular(String? val) {
    prefs.setString('celular', val!);
  }

  static bool? get location {
    if (prefs.getBool('location') != null) {
      return prefs.getBool('location');
    }
    return null;
  }

  static set location(bool? val) {
    prefs.setBool('location', val!);
  }

  static bool? get locationEnabled {
    if (prefs.getBool('location_enabled') != null) {
      return prefs.getBool('location_enabled');
    }
    return null;
  }

  static set locationEnabled(bool? val) {
    prefs.setBool('location_enabled', val!);
  }

  static int? get establishmentId {
    if (prefs.getInt('establishment_id') != null) {
      return prefs.getInt('establishment_id');
    }
    return null;
  }

  static set establishmentId(int? val) {
    prefs.setInt('establishment_id', val!);
  }
}
