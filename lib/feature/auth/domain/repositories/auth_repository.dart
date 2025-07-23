import 'package:chat_app/feature/auth/domain/entities/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<String, AuthEntity>> createAccount(
    String name,
    String email,
    String password,
  );
  Future<Either<String, AuthEntity>> signIn(String email, String password);
  Future<Either<String, void>> forgotPassword(String email);
}
