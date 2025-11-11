import 'package:express/data/models/user_model.dart';
import 'package:express/data/repositories/auth_repository.dart';
import 'package:express/data/storage/secure_storage_service.dart';
import 'package:express/logic/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _storageService;

  AuthCubit(this._authRepository)
    : _storageService = SecureStorageService(),
      super(AuthInitial());

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (!isLoggedIn) {
      emit(AuthInitial());
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
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthFailure(errorMessage));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.signIn(
        email: email,
        password: password,
      );

      final user = response.user;

      await _storageService.saveUserData(
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      );

      emit(AuthSignInSuccess(user));
    } catch (e, stackTrace) {
      print('SignIn Error: $e');
      print(stackTrace);

      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthFailure(errorMessage));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _storageService.clearStorage();
    emit(AuthInitial());
  }
}
