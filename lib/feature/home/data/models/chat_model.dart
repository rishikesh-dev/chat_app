import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.senderId,
    required super.message,
    required super.sender,
    required super.time,
  });

  factory ChatModel.fromjson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final time = (data['time'] as Timestamp).toDate();
    return ChatModel(
      id: doc.id,
      senderId: data['senderId'] as String,
      message: data['message'] as String,
      sender: data['sender'] as String,
      time: time,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'message': message,
    'sender': sender,
    'time': time.toIso8601String(),
  };

  ChatModel copyWith({
    String? id,
    String? senderId,
    String? message,
    String? sender,
    DateTime? time,
  }) {
    return ChatModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      time: time ?? this.time,
    );
  }
}
