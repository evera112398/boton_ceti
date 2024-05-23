import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:boton_ceti/data/alerts_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'package:boton_ceti/controllers/encryption_controller.dart';
import 'package:boton_ceti/services/local_storage.dart';

class LoginController extends ChangeNotifier {
  bool ok = false;
  Map<dynamic, dynamic> decodeResp = {};

  final String? baseUrl = dotenv.env['API_USUARIOS'];
  final String? appToken = dotenv.env['APP_KEY'];
  final String? appId = dotenv.env['ID_APP'];
  final String? keyCipher = dotenv.env['APP_NAME'];

  late String _baseUrl, _appToken, _appId, _key;
  final EncryptionController encryptController = EncryptionController();

  LoginController() {
    _key = keyCipher ?? '';
    _baseUrl = encryptController.decrypt(baseUrl);
    _appId = encryptController.decrypt(appId);
    _appToken = encryptController.decrypt(appToken);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final passToHash = utf8.encode(password);
      final hashedPassword = sha512.convert(passToHash);

      final requestBody = {
        "usuario": email,
        "password": hashedPassword.toString(),
        "id_aplicacion": _appId
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/login'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        _saveToLocalStorage(decodeResp);
        return {
          'ok': ok,
          'exc': false,
          'payload': '',
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
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde. $ex');
    }
  }

  Future<Map<String, dynamic>> getPerfilTiposAlerta() async {
    try {
      final requestBody = {
        "id_usuario": LocalStorage.idUsuario,
        "id_aplicacion": _appId
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
        "token": LocalStorage.tokenUsuario!
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/getPerfilTiposAlerta'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        _saveUserProfiles(decodeResp);
        return {
          'ok': ok,
          'exc': false,
          'payload': '',
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
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde. $ex');
    }
  }

  Future<Map<String, dynamic>> getUsuario() async {
    try {
      final requestBody = {
        "id_usuario": LocalStorage.idUsuario,
        "id_aplicacion": _appId
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
        _saveUserData(decodeResp);
        return {
          'ok': ok,
          'exc': false,
          'payload': '',
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
          'Sucedió un error inesperado. Inténtalo de nuevo más tarde. $ex');
    }
  }

  Future<String?> readIdUsuario() async {
    final bool? session = LocalStorage.hasSession;
    if (session != null && session) {
      return LocalStorage.tokenUsuario;
    }
    return '';
  }

  Map<String, dynamic> _handleError(String message) {
    return {
      'ok': ok,
      'exc': true,
      'payload': message,
    };
  }

  Future<void> _saveToLocalStorage(Map<dynamic, dynamic> data) async {
    LocalStorage.idUsuario = data['id_usuario'];
    LocalStorage.idPerfil = data['id_perfil'];
    LocalStorage.tokenUsuario = data['token'];
    LocalStorage.hasSession = true;
    LocalStorage.location = false;
    await getUsuario();
  }

  void _saveUserData(Map<dynamic, dynamic> data) {
    final userData = data['usuario'];
    LocalStorage.nombre = userData['nombre'];
    LocalStorage.apellidoPaterno = userData['apellido_paterno'];
    LocalStorage.apellidoMaterno = userData['apellido_materno'];
    LocalStorage.correo = userData['correo'];
    LocalStorage.celular = userData['celular'];
  }

  void _saveUserProfiles(Map<dynamic, dynamic> data) {
    LocalStorage.clearUserProfiles();
    final userProfiles = data['tipos_alerta'];
    List userCastedProfiles = [];
    for (final profile in userProfiles) {
      final AlertData profileData = AlertData(
        alertTitle: profile['nombre'],
        alertText: profile['descripcion'],
        resourcePath: profile['path'],
        alertId: profile['id_tipo_alerta'],
      );
      userCastedProfiles.add(profileData);
    }
    LocalStorage.userProfiles = json.encode(userCastedProfiles);
  }
}
