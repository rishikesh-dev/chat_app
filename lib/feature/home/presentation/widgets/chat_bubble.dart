import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isSelected;
  final bool isMe;
  final String message;
  final bool showAvatar;
  final String senderInitial;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.showAvatar,
    required this.senderInitial,
    this.isSelected = false,
    this.onLongPress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isSelected
        ? Colors.green.shade900
        : isMe
        ? const Color(0xFF3F3F3F)
        : const Color(0xFF018068);

    final senderCard = CircleAvatar(
      backgroundColor: isSelected
          ? Colors.green.shade900.withAlpha(100)
          : Theme.of(context).cardColor,
      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
      radius: 20,
      child: Text(
        senderInitial.isNotEmpty
            ? senderInitial
                  .substring(0, senderInitial.length.clamp(0, 2))
                  .toUpperCase()
            : '?',
      ),
    );

    final bubble = Bubble(
      style: BubbleStyle(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
        color: bubbleColor,
        margin: const BubbleEdges.only(top: 4, left: 2, right: 2),
        radius: const Radius.circular(12),
        showNip: showAvatar,
      ),
      child: SizedBox(
        width: IntrinsicWidth().stepWidth,
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: ColoredBox(
        color: isSelected
            ? const Color.fromARGB(255, 56, 56, 56).withAlpha(250)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: isMe
                ? [
                    bubble,
                    if (showAvatar) const SizedBox(width: 8),
                    if (showAvatar) senderCard,
                  ]
                : [
                    if (showAvatar) senderCard,
                    if (showAvatar) const SizedBox(width: 8),
                    bubble,
                  ],
          ),
        ),
      ),
    );
  }
}
