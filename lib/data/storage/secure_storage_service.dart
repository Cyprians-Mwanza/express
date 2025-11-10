import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String keyEmail = 'email';
  static const String keyFirstName = 'first_name';
  static const String keyLastName = 'last_name';
  static const String keyRole = 'role';
  static const String keyAccessToken = 'access_token';

  Future<void> saveUserData({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    await _storage.write(key: keyEmail, value: email);
    await _storage.write(key: keyFirstName, value: firstName);
    await _storage.write(key: keyLastName, value: lastName);
    await _storage.write(key: keyRole, value: role);
  }

  Future<Map<String, String?>> readUserData() async {
    final email = await _storage.read(key: keyEmail);
    final firstName = await _storage.read(key: keyFirstName);
    final lastName = await _storage.read(key: keyLastName);
    final role = await _storage.read(key: keyRole);

    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    };
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: keyAccessToken, value: token);
  }

  Future<String?> readAccessToken() async {
    return await _storage.read(key: keyAccessToken);
  }

  Future<void> clearAccessToken() async {
    await _storage.delete(key: keyAccessToken);
  }
}
