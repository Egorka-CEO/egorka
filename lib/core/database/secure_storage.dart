import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySecureStorage {
  final storage = const FlutterSecureStorage();

  Future<String?> getID() => storage.read(key: 'ID');

  void setID(String token) => storage.write(key: 'ID', value: token);

  Future<String?> getSecure() => storage.read(key: 'Secure');

  void setSecure(String token) => storage.write(key: 'Secure', value: token);
}