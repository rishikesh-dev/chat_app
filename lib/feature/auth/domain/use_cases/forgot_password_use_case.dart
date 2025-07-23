import 'package:chat_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase({required this.repository});
  Future<Either<String, void>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
