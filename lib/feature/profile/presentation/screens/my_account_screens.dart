import 'package:chat_app/core/widgets/rounded_button_widget.dart';
import 'package:chat_app/core/widgets/text_field_widget.dart';
import 'package:chat_app/feature/auth/presentation/screens/forgot_password.dart';
import 'package:chat_app/feature/profile/presentation/bloc/update_account_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class MyAccountScreens extends StatefulWidget {
  const MyAccountScreens({super.key, required this.user});

  final User user;
  @override
  State<MyAccountScreens> createState() => _MyAccountScreensState();
}

class _MyAccountScreensState extends State<MyAccountScreens> {
  late TextEditingController _nameController;
  String username = '';
  late TextEditingController _emailController;
  @override
  void initState() {
    super.initState();

    username = widget.user.displayName ?? 'Unkown';
    _emailController = TextEditingController(text: widget.user.email);
    _nameController = TextEditingController(text: username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: BlocConsumer<UpdateAccountBloc, UpdateAccountState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              toastification.show(
                title: Text('Your Account has been deleted successfully'),
                description: Text(
                  'Thanks for using my app🙏🫂\n you will redirected to welcome screen',
                ),
              );
            }
            if (state is UpdateAccountError) {
              toastification.show(
                title: Text('Your Account deletion failed'),
                description: Text('Sorry for that😔,please try again'),
              );
            }
            if (state is UpdateAccountSuccess) {
              toastification.show(
                title: Text('Your name has changed successfully'),
                description: Text(
                  '$username to ${_nameController.text.trim()}',
                ),
              );
            }
            if (state is UpdateAccountError) {
              toastification.show(
                showProgressBar: true,
                showIcon: false,
                title: Text('Your name has Failed'),
                description: Text(state.message),
              );
            }
          },
          builder: (context, state) {
            return Form(
              child: Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).cardColor,
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Text(
                      username.characters.take(2).string,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  TextFieldWidget(
                    icon: Icons.person,
                    hintText: 'Enter you name',
                    controller: _nameController,
                  ),
                  TextFieldWidget(
                    isReadOnly: true,
                    isFilled: true,
                    fillColor: Colors.grey.shade900,
                    icon: Icons.email_outlined,
                    hintText: 'Enter you Email',
                    controller: _emailController,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (ctx) => ForgotPassword()),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  RoundedButtonWidget(
                    label: 'Update',
                    onPressed: () {
                      context.read<UpdateAccountBloc>().add(
                        UpdateAccountDetailsEvent(
                          name: _nameController.text.trim(),
                        ),
                      );
                    },
                  ),
                  RoundedButtonWidget(
                    bgColor: Colors.red.withAlpha(230),
                    icon: Icon(Icons.delete),
                    label: 'Delete Account',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            'Are you sure you want to delete your account?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<UpdateAccountBloc>().add(
                                  DeleteAccountEvent(userId: widget.user.uid),
                                );
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
