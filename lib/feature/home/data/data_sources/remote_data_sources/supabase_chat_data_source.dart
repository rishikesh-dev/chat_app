import 'package:chat_app/feature/home/data/models/chat_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseChatDataSource {
  final SupabaseClient supabase;

  SupabaseChatDataSource({required this.supabase});

  /// Send a message to Supabase
  Future<Either<String, ChatModel>> sendMessage(String message) async {
    final user = supabase.auth.currentUser;
    if (user == null) return left("User not authenticated");

    try {
      final response = await supabase
          .from('chats')
          .insert({
            'senderId': user.id,
            'message': message,
            'sender': user.userMetadata?['name'] ?? 'Anonymous',
            'time': DateTime.now().toIso8601String(),
          })
          .select()
          .single(); // return inserted row

      final data = response;
      return right(ChatModel.fromjson(data));
    } catch (e) {
      return left('Failed to send message: $e');
    }
  }
}
