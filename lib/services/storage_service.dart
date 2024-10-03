import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class StorageService {
  late bool useFileSystem;
  Database? _database;

  bool isFileSystem = true;

  void switchEngine(bool isFileSystem) {
    isFileSystem = isFileSystem;
  }

  final encrypt.Key key = encrypt.Key.fromLength(32);
  final encrypt.IV iv = encrypt.IV.fromLength(16);

  Future<void> init({required bool useFileSystem}) async {
    this.useFileSystem = useFileSystem;

    if (!useFileSystem) {
      _database = await _initDatabase();
    }
  }

  Future<void> storeResult(String expression, double result) async {
    if (useFileSystem) {
      await _storeResultInFileSystem(expression, result);
    } else {
      await _storeResultInDatabase(expression, result);
    }
  }

  Future<List<Map<String, dynamic>>> loadRecentResults() async {
    if (useFileSystem) {
      return await _loadResultsFromFileSystem();
    } else {
      return await _loadResultsFromDatabase();
    }
  }

  Future<void> _storeResultInFileSystem(
      String expression, double result) async {
    final file = await _getFile();
    final List<Map<String, dynamic>> results =
        await _loadResultsFromFileSystem();

    results.add({
      'expression': expression,
      'result': result,
    });

    final encryptedData = _encryptData(jsonEncode(results));
    await file.writeAsString(encryptedData);
  }

  Future<List<Map<String, dynamic>>> _loadResultsFromFileSystem() async {
    final file = await _getFile();

    if (await file.exists()) {
      final encryptedData = await file.readAsString();
      final decryptedData = _decryptData(encryptedData);
      return List<Map<String, dynamic>>.from(jsonDecode(decryptedData));
    }

    return [];
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/results.json');
  }

  String _encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String _decryptData(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }

  Future<void> _storeResultInDatabase(String expression, double result) async {
    await _database?.insert('results', {
      'expression': expression,
      'result': result,
    });
  }

  Future<List<Map<String, dynamic>>> _loadResultsFromDatabase() async {
    return await _database?.query('results') ?? [];
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/results.db';

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE results (id INTEGER PRIMARY KEY AUTOINCREMENT, expression TEXT, result REAL)',
        );
      },
    );
  }
}
