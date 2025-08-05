import 'package:chat_app/feature/auth/data/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class RemoteAuthDataSource {
  final FirebaseAuth auth;

  RemoteAuthDataSource({required this.auth});
  Future<Either<String, AuthModel>> createUser(
    String name,
    String email,
    String password,
  ) async {
    try {
      final UserCredential response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return left(
          'User creation failed. Check if email verification is required.',
        );
      }
      user.updateDisplayName(name);
      return right(AuthModel.fromDB(user));
    } on FirebaseException catch (e) {
      final message = e.message!.trim();
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
      final UserCredential response = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return left('User sign In failed. Check if email exists.');
      }

      return right(AuthModel.fromDB(user));
    } on FirebaseAuthException catch (e) {
      final code = e.code;
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
      await auth.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      final message = e.message!.trim();
      return left(
        message.isNotEmpty ? message : 'Failed to send password reset email.',
      );
    } catch (e) {
      return left('Unexpected error: ${e.toString()}');
    }
  }
}
