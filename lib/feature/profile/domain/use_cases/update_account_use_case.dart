import 'package:chat_app/feature/profile/domain/repositories/update_account_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAccountUseCase {
  final UpdateAccountRepository repository;
  UpdateAccountUseCase({required this.repository});

  Future<Either<String, void>> updateAccount(String name) async {
    return await repository.updateAccount(name);
  }
}
