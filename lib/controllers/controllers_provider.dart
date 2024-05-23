import 'package:boton_ceti/controllers/alertas_controller.dart';
import 'package:boton_ceti/controllers/encryption_controller.dart';
import 'package:boton_ceti/controllers/login_controller.dart';
import 'package:boton_ceti/controllers/usuario_controller.dart';
import 'package:flutter/material.dart';

class ControllersProvider extends ChangeNotifier {
  final LoginController loginController = LoginController();
  final EncryptionController encryptionController = EncryptionController();
  final AlertasController alertasController = AlertasController();
  final UsuariosController usuariosController = UsuariosController();

  ControllersProvider._privateConstructor();
  static final ControllersProvider instance =
      ControllersProvider._privateConstructor();
}
