import 'package:chat_app/feature/auth/domain/entities/auth_entity.dart';
import 'package:chat_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateAccountUseCase {
  final AuthRepository repository;

  CreateAccountUseCase({required this.repository});
  Future<Either<String, AuthEntity>> call(
    String name,
    String email,
    String password,
  ) async {
    try {
      return await repository.createAccount(name, email, password);
    } catch (e) {
      return left(e.toString());
    }
  }
}
