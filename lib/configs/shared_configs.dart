// ignore_for_file: prefer_const_constructors

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedConfigs {
  final storage = FlutterSecureStorage();
  // final key = 'defaultKey';

// Read value
  Future<String?> readKey(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

// Read all values
  Future<Map<String, String>> readAll() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }

// Delete value
// await storage.delete(key: key);

// Delete all
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
// await storage.deleteAll();

  Future<void> writeKey(String key, String value) async {
    await storage.write(key: key, value: value);
  }

// Write value

}
