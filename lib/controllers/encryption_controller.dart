import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class EncryptionController extends ChangeNotifier {
  late String _key;
  late final crypt.IV _iv;
  EncryptionController() {
    _key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpX';
    _iv = crypt.IV.fromBase64('NvWuoUYcUJzgcun9SsB2Rg==');
  }
  String decrypt(text) {
    final key = crypt.Key.fromUtf8(_key);
    final encrypter = crypt.Encrypter(crypt.AES(key));
    final decrypted = encrypter.decrypt64(text, iv: _iv);
    return decrypted;
  }

  String encrypt(plainText) {
    final key = crypt.Key.fromUtf8(_key);
    final encrypter = crypt.Encrypter(crypt.AES(key));
    var encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64.toString();
  }
}
