import 'package:chat_app/feature/auth/data/models/auth_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDataSource {
  final SupabaseClient supabase;

  SupabaseAuthDataSource({required this.supabase});
  Future<Either<String, AuthModel>> createUser(
    String name,
    String email,
    String password,
  ) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user == null) {
        return left(
          'User creation failed. Check if email verification is required.',
        );
      }

      return right(AuthModel.fromDB(user.toJson()));
    } on AuthException catch (e) {
      final message = e.message.trim();
      return left(
        message.isNotEmpty == true ? message : 'Authentication failed.',
      );
    }
  }

  Future<Either<String, AuthModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return left('User sign In failed. Check if email exists.');
      }

      return right(AuthModel.fromDB(user.toJson()));
    } on AuthException catch (e) {
      final code = e.code ?? 'unknown_error';
      final message = code.contains('email_not_confirmed')
          ? 'Please confirm your email before signing in.'
          : code
                .replaceAll('_', ' ')
                .replaceFirstMapped(
                  RegExp(r'^\w'),
                  (m) => m.group(0)!.toUpperCase(),
                );

      return left(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Either<String, void>> forgotPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      return right(null);
    } on AuthException catch (e) {
      final message = e.message.trim();
      return left(
        message.isNotEmpty ? message : 'Failed to send password reset email.',
      );
    } catch (e) {
      return left('Unexpected error: ${e.toString()}');
    }
  }
}
