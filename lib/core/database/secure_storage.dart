import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySecureStorage {
  final storage = const FlutterSecureStorage();

  static const String id = 'ID';
  static const String key = 'KEY';
  static const String secure = 'Secure';
  static const String login = 'Login';
  static const String password = 'Password';
  static const String company = 'Company';
  static const String typeAuth = 'TypeAuth'; // 0-username, 1-email, 2-phone
  static const String typeUser = 'TypeUser'; // 0-user, 1-company

  Future<String?> getKey() => storage.read(key: key);

  void setKey(String? value) => storage.write(key: key, value: value);

  Future<String?> getID() => storage.read(key: id);

  void setID(String? value) => storage.write(key: id, value: value);

  Future<String?> getSecure() => storage.read(key: secure);

  void setSecure(String? value) => storage.write(key: secure, value: value);

  Future<String?> getLogin() => storage.read(key: login);

  void setLogin(String? value) => storage.write(key: login, value: value);

  Future<String?> getPassword() => storage.read(key: password);

  void setPassword(String? value) => storage.write(key: password, value: value);

  Future<String?> getCompany() => storage.read(key: company);

  void setCompany(String? value) => storage.write(key: company, value: value);

  Future<String?> getTypeAuth() => storage.read(key: typeAuth);

  void setTypeAuth(String? value) =>
      storage.write(key: typeAuth, value: value);

  Future<String?> getTypeUser() => storage.read(key: typeUser);

  void setTypeUser(String? value) =>
      storage.write(key: typeUser, value: value);
}
