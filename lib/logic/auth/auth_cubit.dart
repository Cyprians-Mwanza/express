import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:express/data/models/user_model.dart';
import 'package:express/data/repositories/auth_repository.dart';
import 'package:express/data/storage/secure_storage_service.dart';
import 'package:express/logic/auth/auth_state.dart';
import '../../core/network/failure.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _storageService;

  AuthCubit(this._authRepository)
    : _storageService = SecureStorageService(),
      super(const AuthInitial());

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (!isLoggedIn) {
      emit(const AuthInitial());
      return;
    }

    try {
      final userData = await _storageService.readUserData();
      final email = userData['email'];
      final firstName = userData['first_name'];
      final lastName = userData['last_name'];
      final role = userData['role'];

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
        emit(const AuthInitial());
      }
    } catch (_) {
      emit(const AuthFailure('Session expired. Please log in again.'));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    emit(const AuthLoading());

    final result = await _authRepository.signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
    );

    result.fold(
      (Failure failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthSignUpSuccess(message: 'Registration successful!')),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());

    final result = await _authRepository.signIn(
      email: email,
      password: password,
    );

    result.fold((Failure failure) => emit(AuthFailure(failure.message)), (
      response,
    ) async {
      final user = response.user;
      await _storageService.saveUserData(
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      );
      emit(AuthSignInSuccess(user));
    });
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _storageService.clearStorage();
    emit(const AuthInitial());
  }
}
