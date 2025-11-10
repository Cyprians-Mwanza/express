import 'package:equatable/equatable.dart';
import 'package:express/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSignUpSuccess extends AuthState {
  final String message;
  const AuthSignUpSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignInSuccess extends AuthState {
  final UserModel user;
  const AuthSignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
