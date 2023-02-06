import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySecureStorage {
  final storage = const FlutterSecureStorage();

  static const String ID = 'ID';
  static const String KEY = 'KEY';
  static const String SECURE = 'Secure';
  static const String LOGIN = 'Login';
  static const String PASSWORD = 'Password';
  static const String COMPANY = 'Company';
  static const String TYPE_AUTH = 'TypeAuth'; // 0-username, 1-email, 2-phone
  static const String TYPE_USER = 'TypeUser'; // 0-user, 1-company

  Future<String?> getKey() => storage.read(key: KEY);

  void setKey(String? value) => storage.write(key: KEY, value: value);

  Future<String?> getID() => storage.read(key: ID);

  void setID(String? value) => storage.write(key: ID, value: value);

  Future<String?> getSecure() => storage.read(key: SECURE);

  void setSecure(String? value) => storage.write(key: SECURE, value: value);

  Future<String?> getLogin() => storage.read(key: LOGIN);

  void setLogin(String? value) => storage.write(key: LOGIN, value: value);

  Future<String?> getPassword() => storage.read(key: PASSWORD);

  void setPassword(String? value) => storage.write(key: PASSWORD, value: value);

  Future<String?> getCompany() => storage.read(key: COMPANY);

  void setCompany(String? value) => storage.write(key: COMPANY, value: value);

  Future<String?> getTypeAuth() => storage.read(key: TYPE_AUTH);

  void setTypeAuth(String? value) =>
      storage.write(key: TYPE_AUTH, value: value);

  Future<String?> getTypeUser() => storage.read(key: TYPE_USER);

  void setTypeUser(String? value) =>
      storage.write(key: TYPE_USER, value: value);
}
