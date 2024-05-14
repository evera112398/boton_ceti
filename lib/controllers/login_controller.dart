import 'dart:async';
import 'dart:convert';

import 'package:boton_ceti/controllers/encryption_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class LoginController extends ChangeNotifier {
  final String? baseUrl = dotenv.env['API_USUARIOS'];
  final String? appToken = dotenv.env['APP_KEY'];
  final String? appId = dotenv.env['ID_APP'];
  final String? keyCipher = dotenv.env['APP_NAME'];
  late String _baseUrl, _appToken, _appId, _key;
  EncryptionController encryptController = EncryptionController();

  LoginController() {
    _key = keyCipher ?? '';
    _baseUrl = encryptController.decrypt(baseUrl);
    _appId = encryptController.decrypt(appId);
    _appToken = encryptController.decrypt(appToken);
  }

  Future<Map> login(String email, String password) async {
    try {
      final passToHash = utf8.encode(password);
      final hashedPassword = sha512.convert(passToHash);
      final Map<String, dynamic> petitionBody = {
        "usuario": email,
        "password": hashedPassword.toString(),
        "id_aplicacion": _appId
      };
      final Map<String, String> petitionHeaders = {
        "Content-Type": "application/json",
        "auth": _appToken,
      };
      final petitionBodyJson = json.encode(petitionBody);
      final resp = await http
          .post(Uri.parse('$_baseUrl/login'),
              headers: petitionHeaders, body: petitionBodyJson)
          .timeout(const Duration(seconds: 30));
      final Map<String, dynamic> decodeResp = json.decode(resp.body);
      return decodeResp;
    } catch (ex) {
      return {'ex': ex};
    }
  }
}
