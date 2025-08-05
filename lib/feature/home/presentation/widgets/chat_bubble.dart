import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final bool showAvatar;
  final String senderInitial;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.showAvatar,
    required this.senderInitial,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe
        ? const Color.fromARGB(255, 63, 63, 63)
        : const Color.fromARGB(255, 1, 128, 104);
    final senderCard = CircleAvatar(
      backgroundColor: Theme.of(context).cardColor,
      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
      radius: 20,
      child: Text(senderInitial.characters.take(2).string),
    );
    final bubble = Bubble(
      style: BubbleStyle(
        alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
        nip: isMe ? BubbleNip.leftTop : BubbleNip.rightTop,
        color: bubbleColor,
        margin: const BubbleEdges.only(top: 4, left: 2, right: 2),
        radius: const Radius.circular(12),
        showNip: showAvatar,
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: isMe
            ? [showAvatar ? senderCard : SizedBox(width: 50), bubble]
            : [bubble, showAvatar ? senderCard : SizedBox(width: 50)],
      ),
    );
  }
}
