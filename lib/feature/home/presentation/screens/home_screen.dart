import 'package:chat_app/feature/home/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/feature/home/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/feature/home/presentation/widgets/loading_chat.dart';
import 'package:chat_app/feature/home/presentation/widgets/message_text_field.dart';
import 'package:chat_app/feature/profile/presentation/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _messageController;
  final Set<String> _selectedMessageIds = {};

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(StreamMessageEvent());

    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  bool get isSelecting => _selectedMessageIds.isNotEmpty;
  final auth = FirebaseAuth.instance;

  void _toggleSelection(String messageId, String senderId) {
    if (auth.currentUser?.uid == senderId) {
      setState(() {
        if (_selectedMessageIds.contains(messageId)) {
          _selectedMessageIds.remove(messageId);
        } else {
          _selectedMessageIds.add(messageId);
        }
      });
    }
  }

  void _clearSelection() {
    setState(() => _selectedMessageIds.clear());
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    if (user == null) return const LoadingChat();

    final currentUserId = user.uid;
    final displayName = user.displayName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: isSelecting
            ? Text('${_selectedMessageIds.length} selected')
            : const Text("Chat App"),
        leading: isSelecting
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
        actions: [
          if (isSelecting)
            IconButton(
              onPressed: () async {
                final firestore = FirebaseFirestore.instance;
                final currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser == null) return;

                final currentUserId = currentUser.uid;

                // Collect deletable messages
                final List<DocumentReference> deletableDocs = [];

                for (final id in _selectedMessageIds) {
                  final docRef = firestore.collection('chats').doc(id);
                  final doc = await docRef.get();

                  if (doc.exists && doc['senderId'] == currentUserId) {
                    deletableDocs.add(docRef);
                  }
                }

                if (deletableDocs.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No deletable messages selected."),
                      ),
                    );
                  }
                  return;
                }

                // Show confirmation dialog
                if (!context.mounted) return;

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Messages'),
                    content: const Text(
                      'Are you sure you want to delete selected messages?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                // Proceed with batch delete
                final batch = firestore.batch();
                for (final docRef in deletableDocs) {
                  batch.delete(docRef);
                }

                try {
                  await batch.commit();
                  _clearSelection();
                  if (context.mounted) {
                    toastification.show(
                      title: Text('Messages deleted successfully.'),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    toastification.show(
                      title: Text('Failed to delete messages: $e'),
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete),
            ),

          if (!isSelecting)
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const ProfileScreen()),
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Text(displayName[0].toUpperCase()),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return LoadingChat();
                  }
                  if (state is ChatError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is StreamMessageSuccess) {
                    return ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      itemCount: state.chats.length,
                      itemBuilder: (ctx, index) {
                        final chats = state.chats[index];
                        final isMe = currentUserId == chats.senderId;

                        final showAvatar =
                            index == state.chats.length - 1 ||
                            currentUserId != state.chats[index + 1].senderId;

                        return InkWell(
                          onLongPress: () {
                            _toggleSelection(chats.id, chats.senderId);
                          },
                          onTap: () {
                            if (isSelecting) {
                              _toggleSelection(chats.id, chats.senderId);
                            }
                          },
                          child: ChatBubble(
                            isSelected: _selectedMessageIds.contains(chats.id),
                            isMe: isMe,
                            message: chats.message,
                            showAvatar: showAvatar,
                            senderInitial: chats.sender,
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: Text('No data available'));
                },
              ),
            ),

            /// Message input
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
