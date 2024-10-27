import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class AES256CTR {
  final Key key;
  final IV iv;

  AES256CTR(String password)
      : key = Key.fromUtf8(sha256.convert(utf8.encode(password)).toString().substring(0, 32)),
        iv = IV.fromUtf8(sha256.convert(utf8.encode(password)).toString().substring(32, 48));

  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.ctr));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.ctr));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
