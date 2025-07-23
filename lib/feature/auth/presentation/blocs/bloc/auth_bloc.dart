import 'package:chat_app/feature/auth/domain/entities/auth_entity.dart';
import 'package:chat_app/feature/auth/domain/use_cases/create_account_use_case.dart';
import 'package:chat_app/feature/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:chat_app/feature/auth/domain/use_cases/sigin_in_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateAccountUseCase createAccountUseCase;
  final SiginInUseCase siginInUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  AuthBloc(
    this.createAccountUseCase,
    this.siginInUseCase,
    this.forgotPasswordUseCase,
  ) : super(AuthInitial()) {
    on<CreateAccountEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await createAccountUseCase.call(
        event.name,
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(AuthError(message: failure)),
        (user) => emit(CreateAccountSuccess(user)),
      );
    });
    on<SignInAccountEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await siginInUseCase.call(event.email, event.password);
      result.fold(
        (failure) => emit(AuthError(message: failure)),
        (user) => emit(CreateAccountSuccess(user)),
      );
    });
    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await forgotPasswordUseCase.call(event.email);
      response.fold(
        (failure) => emit(AuthError(message: failure)),
        (email) => emit(ForgotPasswordSuccess()),
      );
    });
  }
}
