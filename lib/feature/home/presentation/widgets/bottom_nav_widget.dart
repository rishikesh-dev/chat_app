import 'package:flutter/material.dart';

final ValueNotifier indexNotifier = ValueNotifier(0);

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexNotifier,
      builder: (context, value, child) {
        return BottomNavigationBar(
          selectedItemColor: Theme.of(context).cardColor,
          unselectedItemColor: Colors.grey,
          currentIndex: indexNotifier.value,
          onTap: (value) {
            indexNotifier.value = value;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}
