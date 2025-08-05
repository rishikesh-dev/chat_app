import 'package:chat_app/feature/auth/domain/entities/auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel extends AuthEntity {
  AuthModel({required super.id, required super.name, required super.email});
  factory AuthModel.fromDB(User user) {
    return AuthModel(
      id: user.uid,
      name: user.displayName as String,
      email: user.email as String,
    );
  }
  Map<String, dynamic> toDB() {
    return {'id': id, 'name': name, 'email': email};
  }
}
