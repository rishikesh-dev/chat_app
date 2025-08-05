import 'package:chat_app/feature/profile/data/data_sources/remote_data_sources/remote_account_data_source.dart';
import 'package:chat_app/feature/profile/domain/repositories/update_account_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAccountRepositoryImpl extends UpdateAccountRepository {
  final RemoteAccountDataSource dataSource;

  UpdateAccountRepositoryImpl({required this.dataSource});
  @override
  Future<Either<String, void>> updateAccount(String name) async {
    return await dataSource.updateAccount(name);
  }

  @override
  Future<Either<String, void>> deleteAccount(String userId) async {
    return await dataSource.deleteAccount(userId);
  }
}
