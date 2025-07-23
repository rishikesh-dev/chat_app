import 'package:chat_app/feature/profile/domain/use_cases/delete_account_use_case.dart';
import 'package:chat_app/feature/profile/domain/use_cases/update_account_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_account_event.dart';
part 'update_account_state.dart';

class UpdateAccountBloc extends Bloc<UpdateAccountEvent, UpdateAccountState> {
  final UpdateAccountUseCase updateAccountUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  UpdateAccountBloc(this.updateAccountUseCase, this.deleteAccountUseCase)
    : super(UpdateAccountInitial()) {
    on<UpdateAccountDetailsEvent>((event, emit) async {
      emit(UpdateAccountLoading());
      final response = await updateAccountUseCase.updateAccount(event.name);
      response.fold(
        (failure) => emit(UpdateAccountError(message: failure)),
        (success) => emit(UpdateAccountSuccess()),
      );
    });
    on<DeleteAccountEvent>((event, emit) async {
      emit(UpdateAccountLoading());
      final response = await deleteAccountUseCase.deleteAccount(event.userId);
      response.fold(
        (failure) => emit(DeleteAccountError(message: failure)),
        (success) => emit(DeleteAccountSuccess()),
      );
    });
  }
}
