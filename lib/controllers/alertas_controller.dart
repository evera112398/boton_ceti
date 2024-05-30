import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:boton_ceti/controllers/encryption_controller.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AlertasController extends ChangeNotifier {
  bool ok = false;
  Map<dynamic, dynamic> decodeResp = {};

  final String? baseUrl = dotenv.env['API_USUARIOS'];
  final String? appToken = dotenv.env['APP_KEY'];
  final String? appId = dotenv.env['ID_APP'];
  final String? keyCipher = dotenv.env['APP_NAME'];

  late String _baseUrl, _appToken, _appId;
  final EncryptionController encryptController = EncryptionController();

  AlertasController() {
    _baseUrl = encryptController.decrypt(baseUrl);
    _appId = encryptController.decrypt(appId);
    _appToken = encryptController.decrypt(appToken);
  }

  Future<Map<String, dynamic>> createAlerta(
      LatLng coordinatesAlerta, int establishmentId, int alertId) async {
    try {
      final requestBody = {
        "id_usuario": LocalStorage.idUsuario,
        "id_aplicacion": _appId,
        "tipo_alerta": alertId,
        "id_establecimiento": establishmentId,
        "latitud": coordinatesAlerta.latitude,
        "longitud": coordinatesAlerta.longitude
      };

      final requestHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
        "token": LocalStorage.tokenUsuario!
      };

      final resp = await http
          .post(Uri.parse('$_baseUrl/createAlerta'),
              headers: requestHeaders, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 30));

      decodeResp = json.decode(resp.body);
      ok = decodeResp['ok'];
      if (ok) {
        return {
          'ok': ok,
          'exc': false,
          'payload': decodeResp['folio'],
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

  Map<String, dynamic> _handleError(String message) {
    return {
      'ok': ok,
      'exc': true,
      'payload': message,
    };
  }
}
