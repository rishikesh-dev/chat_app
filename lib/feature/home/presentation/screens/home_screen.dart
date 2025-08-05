import 'package:chat_app/feature/home/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/feature/home/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/feature/home/presentation/widgets/message_text_field.dart';
import 'package:chat_app/feature/profile/presentation/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _messageController;
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;

    if (user == null) {
      setState(() {});
      return Loading();
    }
    final currentUserId = user.uid;
    final name = user.displayName ?? 'No name';
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Chat App"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (ctx) => ProfileScreen()),
            ),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Text(name[0]),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: firestore
                    .collection('chats')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (ctx, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(child: Loading());
                  }
                  if (snapshots.hasError) {
                    return Center(child: Text('Unable to fetch data.'));
                  }
                  if (snapshots.data == null) {
                    return Center(child: Text('No data'));
                  }
                  if (snapshots.hasData) {
                    return ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(bottom: 10),
                      itemCount: snapshots.data?.docs.length,
                      itemBuilder: (ctx, index) {
                        final messages = snapshots.data;
                        final message = messages?.docs[index];
                        final isMe = currentUserId == message?['senderId'];
                        final senderId = message?['senderId'];
                        final bool isLast = index == messages!.docs.length - 1;

                        final bool showAvatar =
                            isLast ||
                            messages.docs[index + 1]['senderId'] != senderId;
                        return ChatBubble(
                          showAvatar: showAvatar,
                          isMe: isMe,
                          message: message?['message'],
                          senderInitial: message?['sender'] ?? 'U',
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
            MessageTextField(
              messageController: _messageController,
              onPressed: () {
                final text = _messageController.text.trim();
                if (text.isEmpty) return;

                context.read<ChatBloc>().add(SendMessageEvent(message: text));
                _messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) {
          return ChatBubble(
            showAvatar: true,
            isMe: index.isEven ? true : false,
            message: 'Message $index',
            senderInitial: '',
          );
        },
      ),
    );
  }
}
