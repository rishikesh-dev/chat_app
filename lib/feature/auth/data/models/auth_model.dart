import 'package:chat_app/feature/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({required super.id, required super.name, required super.email});
  factory AuthModel.fromDB(Map<String, dynamic> db) {
    return AuthModel(
      id: db['id'] as String,
      name: db['name'] as String,
      email: db['email'] as String,
    );
  }
  Map<String, dynamic> toDB() {
    return {'id': id, 'name': name, 'email': email};
  }
}
