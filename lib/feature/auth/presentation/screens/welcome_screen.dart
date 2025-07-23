import 'package:chat_app/core/widgets/rounded_button_widget.dart';
import 'package:chat_app/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:chat_app/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome to \nChat App',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chat_bubble_2_fill,
              size: 150,
              color: Theme.of(context).cardColor,
            ),
            SizedBox(height: 50),
            RoundedButtonWidget(
              label: 'Create Account',
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (ctx) => SignUpScreen()),
                );
              },
            ),
            RoundedButtonWidget(
              label: 'Sign In',
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (ctx) => SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
