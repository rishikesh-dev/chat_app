part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CreateAccountEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  CreateAccountEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignInAccountEvent extends AuthEvent {
  final String email;
  final String password;

  SignInAccountEvent({required this.email, required this.password});

  @override
  String toString() =>
      'SignInAccountEvent(email: $email, password: [password])';
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}
