abstract class ChatEntity {
  final String senderId;
  final String message;
  final String sender;
  final DateTime time;

  ChatEntity({
    required this.senderId,
    required this.message,
    required this.sender,
    required this.time,
  });
}
