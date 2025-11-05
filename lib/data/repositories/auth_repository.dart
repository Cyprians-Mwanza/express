import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/sign_in_model.dart';
import '../models/sign_up_model.dart';
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
    // Use SignUpModel instead of Map
    final body = SignUpModel(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      // Option 1: if `role` is part of your backend model:
      // add it to SignUpModel and regenerate code
      // Option 2: ignore if backend sets default role
    );

    final response = await _apiClient.signUp(body);
    return response;
  }

  Future<AuthResponseModel> signIn({
    required String email,
    required String password,
  }) async {
    // Use SignInModel instead of Map
    final body = SignInModel(email: email, password: password);
    final response = await _apiClient.signIn(body);

    // Save access token if available
    if (response.session?.accessToken != null) {
      await _storage.write(
        key: 'access_token',
        value: response.session!.accessToken,
      );
    }

    return response;
  }

  Future<List<UserModel>> getUsers() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception("No token found. Please sign in first.");

    return await _apiClient.getUsers("Bearer $token");
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}
