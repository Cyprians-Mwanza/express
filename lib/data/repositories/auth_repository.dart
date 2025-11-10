import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/sign_in_model.dart';
import '../models/sign_up_model.dart';
import '../models/user_model.dart';
import '../storage/secure_storage_service.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepository()
    : _apiClient = ApiClient(DioClient().dio),
      _storageService = SecureStorageService();

  Future<AuthResponseModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      final body = SignUpModel(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      final response = await _apiClient.signUp(body);
      return response;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Sign-up failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred during sign-up.');
    }
  }

  Future<AuthResponseModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final body = SignInModel(email: email, password: password);
      final response = await _apiClient.signIn(body);

      final accessToken = response.session?.accessToken;
      if (accessToken != null) {
        await _storageService.saveAccessToken(accessToken);
      }

      return response;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to sign in';
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred during sign-in.');
    }
  }

  Future<List<UserModel>> getUsers() async {
    final token = await _storageService.readAccessToken();
    if (token == null) throw Exception("No token found. Please sign in first.");

    try {
      return await _apiClient.getUsers("Bearer $token");
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to fetch users';
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching users.');
    }
  }

  Future<void> logout() async {
    await _storageService.clearAccessToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.readAccessToken();
    return token != null;
  }
}
