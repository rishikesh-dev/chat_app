part of 'update_account_bloc.dart';

@immutable
sealed class UpdateAccountState {}

final class UpdateAccountInitial extends UpdateAccountState {}

class UpdateAccountLoading extends UpdateAccountState {}

class UpdateAccountError extends UpdateAccountState {
  final String message;

  UpdateAccountError({required this.message});
}

class UpdateAccountSuccess extends UpdateAccountState {}

class DeleteAccountSuccess extends UpdateAccountState {}

class DeleteAccountError extends UpdateAccountState {
  final String message;

  DeleteAccountError({required this.message});
}
