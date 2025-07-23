import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({
    super.key,
    required this.messageController,
    required this.onPressed,
  });

  final TextEditingController messageController;
  final VoidCallback onPressed;

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  bool _isEmojiVisible = false;
  final FocusNode _focusNode = FocusNode();

  void _toggleEmojiPicker() {
    if (_isEmojiVisible) {
      _focusNode.requestFocus(); // Show keyboard
    } else {
      _focusNode.unfocus(); // Hide keyboard
    }
    setState(() => _isEmojiVisible = !_isEmojiVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.messageController,
                  focusNode: _focusNode,
                  onTap: () {
                    if (_isEmojiVisible) {
                      setState(() => _isEmojiVisible = false);
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.emoji_emotions),
                      onPressed: _toggleEmojiPicker,
                    ),
                    hintText: 'Message',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                onPressed: widget.onPressed,
                padding: const EdgeInsets.all(13),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),

        // Emoji Picker
        Offstage(
          offstage: !_isEmojiVisible,
          child: SizedBox(
            height: 260,
            child: EmojiPicker(
              textEditingController: widget.messageController,
              onBackspacePressed: () {
                final text = widget.messageController.text;
                final selection = widget.messageController.selection;
                if (selection.start > 0) {
                  final newText = text.replaceRange(
                    selection.start - 1,
                    selection.start,
                    '',
                  );
                  widget.messageController.value = TextEditingValue(
                    text: newText,
                    selection: TextSelection.collapsed(
                      offset: selection.start - 1,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
