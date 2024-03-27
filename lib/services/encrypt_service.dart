import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class EncryptService {
  static late IV iv;
  static String aesEncryptionKey = 'secretKey2342341';
  static late Encrypter encrypter;

  static void initEncryption() {
    iv = IV.fromUtf8(aesEncryptionKey);
    encrypter = Encrypter(
        AES(Key.fromUtf8(aesEncryptionKey), mode: AESMode.ctr, padding: null));
  }

  static String encryptJson(Map<String, dynamic> jsonData) {
    final jsonString = jsonEncode(jsonData);
    final encrypted = encrypter.encrypt(jsonString, iv: iv);
    return base64.encode(encrypted.bytes);
  }

  static Map<String, dynamic> decryptJson(String encryptedData) {
    final encryptedBytes = base64.decode(encryptedData);
    final encrypted = Encrypted(encryptedBytes);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    final decryptedJson = jsonDecode(decrypted);
    return decryptedJson;
  }
}
