import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAccountDataSource {
  final SupabaseClient supabase;

  SupabaseAccountDataSource({required this.supabase});
  // This is a demo project. Currently, users can only update their name.
  // To enable email updates, simply include the email in the UserAttributes object.

  Future<Either<String, void>> updateAccount(String name) async {
    try {
      await supabase.auth.updateUser(UserAttributes(data: {'name': name}));
      return right(null);
    } on AuthException catch (e) {
      return left(e.code.toString());
    }
  }

  Future<Either<String, void>> deleteAccount(String userId) async {
    try {
      await supabase.auth.admin.deleteUser(userId);
      return right(null);
    } on AuthException catch (e) {
      return left(e.code.toString());
    }
  }
}
