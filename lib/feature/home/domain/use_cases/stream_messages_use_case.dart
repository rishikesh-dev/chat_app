import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';
import 'package:chat_app/feature/home/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class StreamMessagesUseCase {
  final ChatRepository repository;

  StreamMessagesUseCase({required this.repository});

  Stream<Either<String, List<ChatEntity>>> call() {
    return repository.streamMessage();
  }
}
