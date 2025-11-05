import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository() : _apiClient = ApiClient(DioClient().dio);

  Future<AuthResponseModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    final body = {
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "role": role,
    };

    final response = await _apiClient.signUp(body);
    await _storage.write(key: 'access_token', value: response.accessToken);
    return response;
  }

  Future<AuthResponseModel> signIn({
    required String email,
    required String password,
  }) async {
    final body = {"email": email, "password": password};

    final response = await _apiClient.signIn(body);
    await _storage.write(key: 'access_token', value: response.accessToken);
    return response;
  }

  Future<List<UserModel>> getUsers() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception("No token found. Please sign in first.");

    final response = await _apiClient.getUsers("Bearer $token");
    return response;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}
