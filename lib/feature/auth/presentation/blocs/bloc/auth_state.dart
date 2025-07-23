part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
//Account creation State

class CreateAccountSuccess extends AuthState {
  final AuthEntity authEntity;

  CreateAccountSuccess(this.authEntity);
}

//Sign in function
class SignInAccountSuccess extends AuthState {
  final AuthEntity authEntity;

  SignInAccountSuccess({required this.authEntity});
}

//Forgot password
class ForgotPasswordSuccess extends AuthState {}
