import 'package:chat_app/feature/auth/data/data_sources/remote_data_sources/supabase_auth_data_source.dart';
import 'package:chat_app/feature/auth/domain/entities/auth_entity.dart';
import 'package:chat_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl extends AuthRepository {
  final SupabaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, AuthEntity>> createAccount(
    String name,
    String email,
    String password,
  ) async {
    return await dataSource.createUser(name, email, password);
  }

  @override
  Future<Either<String, AuthEntity>> signIn(
    String email,
    String password,
  ) async {
    return await dataSource.signIn(email, password);
  }

  @override
  Future<Either<String, void>> forgotPassword(String email) async {
    return await dataSource.forgotPassword(email);
  }
}
