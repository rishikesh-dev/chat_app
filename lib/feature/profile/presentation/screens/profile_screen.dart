import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/feature/profile/presentation/screens/my_account_screens.dart';
import 'package:chat_app/feature/profile/presentation/screens/settings_screen.dart';
import 'package:chat_app/feature/profile/presentation/widgets/profile_menu_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final String username = user?.displayName ?? 'Unkown';
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(username: username),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: username.isNotEmpty
                  ? Text(username.characters.take(2).string)
                  : Icon(Icons.person),
              press: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (ctx) => MyAccountScreens(user: user!),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Settings",
              icon: Icon(Icons.settings),
              press: () {
                Navigator.push(
                  context,
                  CupertinoDialogRoute(
                    context: context,
                    builder: (ctx) => SettingsScreen(user: user!),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: Icon(Icons.logout_outlined),
              press: () {
                auth.signOut();
                toastification.show(
                  title: Text('You have logged out'),
                  type: ToastificationType.info,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              username[0],
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, connection) {
              bool connected =
                  connection.connectionState != ConnectionState.none;
              return Positioned(
                right: -1,
                bottom: 0,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: connected ? primaryColor : whiteColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
