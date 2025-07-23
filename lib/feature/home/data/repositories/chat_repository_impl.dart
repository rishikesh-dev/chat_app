import 'package:chat_app/feature/home/data/data_sources/remote_data_sources/supabase_chat_data_source.dart';
import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';
import 'package:chat_app/feature/home/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl extends ChatRepository {
  final SupabaseChatDataSource dataSource;

  ChatRepositoryImpl({required this.dataSource});
  @override
  
  @override
  Future<Either<String, ChatEntity>> sendMessage(String message) async {
    return await dataSource.sendMessage(message);
  }
}
