import 'package:chat_app/feature/home/domain/entity/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.senderId,
    required super.message,
    required super.sender,
    required super.time,
  });

  factory ChatModel.fromjson(Map<String, dynamic> json) => ChatModel(
    senderId: json['senderId'] as String,
    message: json['message'] as String,
    sender: json['sender'] as String,
    time: DateTime.parse(json['time']),
  );

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'message': message,
    'sender': sender,
    'time': time.toIso8601String(),
  };
}
