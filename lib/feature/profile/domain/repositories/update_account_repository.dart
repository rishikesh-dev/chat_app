import 'package:fpdart/fpdart.dart';

abstract class UpdateAccountRepository {
  Future<Either<String, void>> updateAccount(String name);
  Future<Either<String, void>> deleteAccount(String userId);
}
