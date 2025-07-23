import 'package:chat_app/feature/profile/domain/repositories/update_account_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccountUseCase {
  final UpdateAccountRepository repository;

  DeleteAccountUseCase({required this.repository});
  Future<Either<String, void>> deleteAccount(String userId) async {
    return await repository.deleteAccount(userId);
  }
}
