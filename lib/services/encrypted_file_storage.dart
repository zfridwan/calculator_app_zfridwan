import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptedFileStorage {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String _fileName = 'encrypted_results.txt';
  final String _keyName = 'encryption_key';

  Future<String> _getEncryptionKey() async {
    var key = await _secureStorage.read(key: _keyName);
    if (key == null) {
      final generatedKey = encrypt.Key.fromLength(32);
      key = base64UrlEncode(generatedKey.bytes);
      await _secureStorage.write(key: _keyName, value: key);
    }
    return key;
  }

  String _encryptData(String plainText, String encryptionKey) {
    final key = encrypt.Key.fromBase64(encryptionKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String _decryptData(String encryptedText, String encryptionKey) {
    final key = encrypt.Key.fromBase64(encryptionKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

  Future<void> storeEncryptedResult(String expression, double result) async {
    final encryptionKey = await _getEncryptionKey();
    final expressionResult = '$expression = $result';
    final encryptedData = _encryptData(expressionResult, encryptionKey);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    await file.writeAsString('$encryptedData\n', mode: FileMode.append);
  }

  Future<List<String>> loadEncryptedResults() async {
    final encryptionKey = await _getEncryptionKey();

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    if (!await file.exists()) {
      return [];
    }

    final encryptedLines = await file.readAsLines();
    final decryptedResults = encryptedLines.map((encryptedLine) {
      return _decryptData(encryptedLine, encryptionKey);
    }).toList();

    return decryptedResults;
  }
}
