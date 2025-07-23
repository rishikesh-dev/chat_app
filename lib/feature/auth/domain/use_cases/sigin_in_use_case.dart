import 'package:chat_app/feature/auth/domain/entities/auth_entity.dart';
import 'package:chat_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SiginInUseCase {
  final AuthRepository repository;

  SiginInUseCase({required this.repository});
  Future<Either<String, AuthEntity>> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}
