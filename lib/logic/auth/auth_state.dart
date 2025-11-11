import 'package:equatable/equatable.dart';
import 'package:express/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccess extends AuthState {
  final String message;
  AuthSignUpSuccess({this.message = ""});

  @override
  List<Object?> get props => [message];
}

class AuthSignInSuccess extends AuthState {
  final UserModel user;
  AuthSignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
