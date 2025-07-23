import 'package:chat_app/feature/home/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/feature/home/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/feature/home/presentation/widgets/message_text_field.dart';
import 'package:chat_app/feature/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final supabase = Supabase.instance;
    final auth = Supabase.instance.client.auth;
    final user = auth.currentUser;

    if (user == null) {
      setState(() {});
      return CircularProgressIndicator();
    }
    final currentUserId = user.id;
    final name = user.userMetadata?['name'] ?? 'No name';
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
                stream: supabase.client
                    .from('chats')
                    .stream(primaryKey: ['id'])
                    .order('time', ascending: false),
                builder: (ctx, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshots.hasError) {
                    return Center(child: Text('Unable to fetch data.'));
                  }
                  if (snapshots.hasData) {
                    return ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(bottom: 10),
                      itemCount: snapshots.data?.length,
                      itemBuilder: (ctx, index) {
                        final messages = snapshots.data;
                        final message = messages![index];
                        // Determine if avatar should be shown
                        final isMe = currentUserId == message['senderId'];
                        final senderId = message['senderId'];
                        final bool isLast = index == messages.length - 1;

                        final bool showAvatar =
                            isLast ||
                            messages[index + 1]['senderId'] != senderId;
                        return ChatBubble(
                          showAvatar: showAvatar,
                          isMe: isMe,
                          message: message['message'],
                          senderInitial: message['sender'] ?? 'U',
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
