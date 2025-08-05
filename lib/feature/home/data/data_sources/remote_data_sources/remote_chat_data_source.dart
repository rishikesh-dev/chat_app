import 'package:chat_app/feature/home/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class RemoteChatDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  RemoteChatDataSource({required this.firestore, required this.auth});

  /// Send a message to Supabase
  Future<Either<String, ChatModel>> sendMessage(String message) async {
    final user = auth.currentUser;
    if (user == null) return left("User not authenticated");

    try {
      final response = await firestore.collection('chats').add({
        'senderId': user.uid,
        'message': message,
        'sender': user.displayName ?? 'Anonymous',
        'time': DateTime.now().toIso8601String(),
      });
      final data = response;
      return right(ChatModel.fromjson(data as Map<String, dynamic>));
    } catch (e) {
      return left('Failed to send message: $e');
    }
  }
}
