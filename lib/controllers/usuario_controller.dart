import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:boton_ceti/controllers/encryption_controller.dart';
import 'package:boton_ceti/data/user_data.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UsuariosController extends ChangeNotifier {
  bool ok = false;
  Map<dynamic, dynamic> decodeResp = {};

  final bool test = dotenv.env['PRUEBAS']?.toLowerCase() == 'true';
  final String? appToken = dotenv.env['APP_KEY'];
  final String? appId = dotenv.env['ID_APP'];
  final String? keyCipher = dotenv.env['APP_NAME'];

  late String _baseUrl, _appToken, _appId;
  final EncryptionController encryptController = EncryptionController();

  UsuariosController() {
    final String? baseUrl =
        test ? dotenv.env['API_PRUEBAS'] : dotenv.env['API_USUARIOS'];
    _baseUrl = encryptController.decrypt(baseUrl);
    _appId = encryptController.decrypt(appId);
    _appToken = encryptController.decrypt(appToken);
  }

  Future<Map<String, dynamic>> createUsuario(UserData newUser) async {
    try {
      final requestBody = newUser.toJson();
      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/createUsuario'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> sendCodigoValidacionCorreo(String valor) async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
        "tipo": "correo",
        "valor": valor
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/sendCodigoValidacion'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> verificaValidacionCorreo(
      String valor, String codigo) async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
        "tipo": "correo",
        "valor": valor,
        "codigo": codigo
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/verificaValidacion'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> sendCodigoValidacionCelular(String valor) async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
        "tipo": "celular",
        "valor": valor
      };
      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/sendCodigoValidacion'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> verificaValidacionCelular(
      String valor, String codigo) async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
        "tipo": "celular",
        "valor": valor,
        "codigo": codigo
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/verificaValidacion'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> getEstablecimientos() async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/getEstablecimientos'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['establecimientos']
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> recuperarPass(
      String celular, String correo) async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
        "celular": celular,
        "usuario": correo
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/recuperarPass'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {'ok': ok, 'exc': false, 'payload': decodeResp['id_usuario']};
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> validaRecuperarPass(
      String codigo, int idUsuario) async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
        "id_usuario": idUsuario,
        "codigo": codigo,
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/validaRecuperarPass'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> updateRecuperarPass(
      String codigo, int idUsuario, String password) async {
    try {
      final passToHash = utf8.encode(password);
      final hashedPassword = sha512.convert(passToHash);
      final requestBody = {
        "id_aplicacion": _appId,
        "id_usuario": idUsuario,
        "codigo": codigo,
        "password": hashedPassword.toString()
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/updateRecuperarPass'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
        };
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> getUsuario() async {
    try {
      final requestBody = {
        "id_usuario": LocalStorage.idUsuario,
        "id_aplicacion": _appId,
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
        "token": LocalStorage.tokenUsuario!
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/getUsuario'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {'ok': ok, 'exc': false, 'payload': decodeResp['usuario']};
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> updateUsuario(Map userData) async {
    try {
      final requestBody = {
        "id_usuario": LocalStorage.idUsuario,
        "id_aplicacion": _appId,
        "nombre": userData['nombre'],
        "apellido_paterno": userData['apellido_paterno'],
        "apellido_materno": userData['apellido_materno'],
        "correo": userData['correo'],
        "celular": userData['celular'],
        "id_plantel": userData['id_plantel'],
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
        "token": LocalStorage.tokenUsuario!
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/updateUsuario'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {'ok': ok, 'exc': false, 'payload': decodeResp['usuario']};
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Future<Map<String, dynamic>> getAplicacionTerminos() async {
    try {
      final requestBody = {
        "id_aplicacion": _appId,
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/getAplicacionTerminos'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {'ok': ok, 'exc': false, 'payload': decodeResp['terminos']};
      } else {
        decodeResp.remove('ok');
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['message'],
        };
      }
    } on TimeoutException {
      return _handleError(
          'El servidor está tardando en responder. Inténtalo de nuevo más tarde.');
    } on SocketException {
      return _handleError(
          'Verifica tu conexión a internet. Inténtalo de nuevo más tarde.');
    } catch (ex) {
      return _handleError(
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde.');
    }
  }

  Map<String, dynamic> _handleError(String message) {
    return {
      'ok': ok,
      'exc': true,
      'payload': message,
    };
  }
}
