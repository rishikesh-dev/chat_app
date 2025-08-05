import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class RemoteAccountDataSource {
  final FirebaseAuth auth;
  RemoteAccountDataSource({required this.auth});
  // This is a demo project. Currently, users can only update their name.

  Future<Either<String, void>> updateAccount(String name) async {
    try {
      await auth.currentUser?.updateDisplayName(name);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(e.code.toString());
    }
  }

  Future<Either<String, void>> deleteAccount(String userId) async {
    try {
      await auth.currentUser?.delete();
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(e.code.toString());
    }
  }
}
