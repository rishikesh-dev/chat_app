import 'package:chat_app/feature/home/presentation/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingChat extends StatelessWidget {
  const LoadingChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade600,
      enabled: true,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final isMe = index.isEven ? true : false;
          return Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              ChatBubble(
                isMe: isMe,
                message: 'message $index',
                showAvatar: true,
                senderInitial: 'U',
              ),
            ],
          );
        },
      ),
    );
  }
}
