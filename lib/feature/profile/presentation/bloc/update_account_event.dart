part of 'update_account_bloc.dart';

@immutable
sealed class UpdateAccountEvent {}

class UpdateAccountDetailsEvent extends UpdateAccountEvent {
  final String name;

  UpdateAccountDetailsEvent({required this.name});
}

class DeleteAccountEvent extends UpdateAccountEvent {
  final String userId;

  DeleteAccountEvent({required this.userId});
}
