import 'package:chat_app/feature/home/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class RemoteChatDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  RemoteChatDataSource({required this.firestore, required this.auth});
  Stream<Either<String, List<ChatModel>>> streamMessage() {
    try {
      final response = firestore
          .collection('chats')
          .orderBy('time', descending: true)
          .limit(50)
          .snapshots();

      return response.map((snapshot) {
        final message = snapshot.docs.map((doc) {
          return ChatModel.fromjson(doc);
        }).toList();
        return right<String, List<ChatModel>>(message);
      });
    } catch (e) {
      return Stream.value(left('Failed to fetch messages :$e'));
    }
  }

  /// Send a message to Firebase
  Future<Either<String, ChatModel>> sendMessage(String message) async {
    final user = auth.currentUser;
    if (user == null) return left("User not authenticated");

    try {
      final now = DateTime.now();
      final chatMap = {
        'senderId': user.uid,
        'sender': user.displayName ?? 'Anonymous',
        'message': message,
        'time': now,
      };

      final docRef = await firestore.collection('chats').add(chatMap);

      final chatWithId = ChatModel(
        id: docRef.id,
        senderId: user.uid,
        sender: user.displayName ?? 'Anonymous',
        message: message,
        time: now,
      );

      return right(chatWithId);
    } catch (e) {
      return left('Failed to send message: $e');
    }
  }
}
