import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clearStorage(BuildContext context) async {
    await prefs.clear();
    Future.microtask(
      () => Navigator.of(context).pushAndRemoveUntil(
          crearRutaNamed(const LoginScreen(), 'loginScreen'), (route) => false),
    );
  }

  static Future<void> clearUserProfiles() async {
    userProfiles = '';
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
}
