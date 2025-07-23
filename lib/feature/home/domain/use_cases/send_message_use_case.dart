import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';
import 'package:chat_app/feature/home/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase({required this.repository});
  Future<Either<String, ChatEntity>> call(String message) async {
    return repository.sendMessage(message);
  }
}
