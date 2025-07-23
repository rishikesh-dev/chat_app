import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ChatRepository {
  Future<Either<String, ChatEntity>> sendMessage(String message);
}
