import 'package:express/data/models/user_model.dart';
import 'package:express/data/repositories/auth_repository.dart';
import 'package:express/logic/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (!isLoggedIn) {
      emit(AuthInitial());
      return;
    }

    try {
      final email = await _storage.read(key: 'email');
      final firstName = await _storage.read(key: 'first_name');
      final lastName = await _storage.read(key: 'last_name');
      final role = await _storage.read(key: 'role');

      if (email != null) {
        final user = UserModel(
          id: '',
          email: email,
          password: '',
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          role: role ?? '',
        );
        emit(AuthSignInSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e, stackTrace) {
      print('CheckLoginStatus Error: $e');
      print(stackTrace);
      emit(AuthFailure("Session expired. Please log in again."));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );
      emit(AuthSignUpSuccess());
    } catch (e, stackTrace) {
      print('SignUp Error: $e');
      print(stackTrace);
      emit(AuthFailure("Sign-up failed. Please try again."));
    }
  }

  /// 🔐 Handle login
  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.signIn(
        email: email,
        password: password,
      );

      final user = response.user;

      // Save user info in secure storage for persistence
      await _storage.write(key: 'email', value: user.email);
      await _storage.write(key: 'first_name', value: user.firstName);
      await _storage.write(key: 'last_name', value: user.lastName);
      await _storage.write(key: 'role', value: user.role);

      emit(AuthSignInSuccess(user));
    } catch (e, stackTrace) {
      print('SignIn Error: $e');
      print(stackTrace);
      emit(AuthFailure("Failed to sign in. Please check your credentials."));
    }
  }

  /// 🚪 Log out and clear all saved data
  Future<void> logout() async {
    await _authRepository.logout();
    await _storage.deleteAll();
    emit(AuthInitial());
  }
}
