import 'package:express/data/repositories/auth_repository.dart';
import 'package:express/logic/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState>{
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository)  : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
}) async{
    emit(AuthLoading());
try{
  final response = await _authRepository.signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
  );
  emit(AuthSuccess(response.user));
}catch(e){
  emit(AuthFailure(e.toString()));
}
  }

  Future<void> signIn({
    required String email,
    required String password,
}) async {
    emit(AuthLoading());
    try{
      final response = await _authRepository.signIn(
          email: email,
          password: password,
      );
      emit(AuthSuccess(response.user));

    }catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if(isLoggedIn){
      emit(AuthSuccess(
        await _authRepository.getUsers().then((users) => users.first),
      ));
    }else{
      emit(AuthInitial());
    }
  }
  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthInitial());
  }

}